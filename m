Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844664756CE;
	Tue, 15 Sep 2026 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511150; cv=none; b=Yvkw9tHAopHLRuw/89vNWHepW/weHiLvRPt6+xL4fXi8el44GM+xqaum6yMrUcA429e9CsA3bWY/oyrRtPh0BZdKM/7u7q02R/d88myY9272i8aWlSbFHhuCdE03xSulkHlxxD9LHiUJpsLglhNtiD1wHtDbM1IU3IeTJFJPoqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511150; c=relaxed/simple;
	bh=pw3Hb3ywPDAx4MtbECEBY7wrRbYrnt5sZDofeJN8zww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4T6GmqsFhUFMkpO03balExQGux5SO77cCzxLFttqN3L43OhkoE9EcyuBF1JTQYuyWUk3Hp/dygySDxvJgMSw/ZWR2Iqfv3l95R3KR9D4T1MQmMzJHflkhxOyeJEMG95w3SjowglUhbbG1vvOW8YkfG5QAZMxIB18KHK08W3hxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfCs8JiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfCs8JiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1898B1F0089C;
	Tue, 15 Sep 2026 22:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511148;
	bh=WEoMCLrX9qhF+MwQQKI/YpW0gHCUAmFuEJOXHcmJAuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfCs8JiCZJFo7pJtYAP9WfYkj9QsUFVBDEzHAyjRp8Q+9tIAX+Sa9bPBKDFQvJhls
	 Ebkc8cPPMjMJWICaQcO/Qtkp+NonXkp8ZNUG6ym+FSZn1qPVAX5sBvWR2guBbtOTTq
	 fbC2dQwH4eKCUdqMEWBeqWAGmF7xy8w+l/X6SxcSRw3yrp9e8lsBnnRDZGOdKXwKvo
	 CLfXLpMAvJxijQLRoXdCPv6+inCT91+1NSGx12Xd/0dxHrpUsRFfo0mCikD0uATrQh
	 x9xhid87wFNyUKNPFTH7CE4GdByWh0MoZCApyOZ66th6UJPECeMW/Till70ZWIi9RX
	 mCVkQ0J+n0Z5g==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2] KVM: selftests: fix steal_time for arm64 with host page size > 4K
Date: Tue, 15 Sep 2026 15:25:40 -0700
Message-ID: <178951103688.10790.15889982999400525367.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914131013.60334-1-sebott@redhat.com>
References: <20260914131013.60334-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 14 Sep 2026 15:10:13 +0200, Sebastian Ott wrote:
> Fix the following failure when running with 16K host page size:
> ==== Test Assertion Failure ====
>   lib/kvm_util.c:991: vm_adjust_num_guest_pages(vm->mode, npages) == npages
>   pid=873 tid=873 errno=0 - Success
>      1  0x0000000000405a27: vm_mem_add at kvm_util.c:991
>      2  0x000000000040241f: check_steal_time_uapi at steal_time.c:223 (discriminator 7)
>      3   (inlined by) main at steal_time.c:539 (discriminator 7)
>      4  0x00007fff8b57af3b: ?? ??:0
>      5  0x00007fff8b57b007: ?? ??:0
>      6  0x0000000000402b6f: _start at ??:?
>   Number of guest pages is not compatible with the host. Try npages=4
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: fix steal_time for arm64 with host page size > 4K
      https://git.kernel.org/kvmarm/kvmarm/c/96e6757cb067

--
Best,
Oliver
