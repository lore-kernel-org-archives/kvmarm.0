Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688DD471414;
	Mon,  7 Sep 2026 11:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782310; cv=none; b=bauTITarg4jIaCjVZ+Nw0yN18Fo4PJCtdYRQ4EelaN5zys2dnUfI7xVMVNvDHV3J7TtuP4KmSLf2Jo1YUOXPgWwoLAMEFt3uSkrw7eDaeFjg3cxU+F/K0/Oy5UnSg6EmOQiP8UBxi9zBPQDMePtDiRzgKyeTx3Hn0VPaA0vk7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782310; c=relaxed/simple;
	bh=gHwRph0Z5WbvmGMENEbvpJ0xv8gch4+5KPFj4oIECLs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A4JmLWnh4PLRwxt5Qct0pzE+gJuftpastPaRW6EtXwKlZT+LeRvdNrtaZ/PSUSNxsNLdiGZxnCH7zojDItihnAcSUEkT3mySDU0tBdwVC9guYJsvRfywYXoJjdQGPdUYqrMkjBOYmrk8godrBUWDyFCE8yeMXWe3V6fLjMnxPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s0dj+247; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s0dj+247"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C60F61476;
	Mon,  7 Sep 2026 04:58:23 -0700 (PDT)
Received: from [10.57.49.168] (unknown [10.57.49.168])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19F283F7D8;
	Mon,  7 Sep 2026 04:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788782307; bh=gHwRph0Z5WbvmGMENEbvpJ0xv8gch4+5KPFj4oIECLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s0dj+247ZGrYRAJTtXRI8Mg3u9DU79+m+Ys2NgoXAglWLE1feLSkomIwC2zA5A5ge
	 GJPItChzLznQD61LkUo/IXNotgwIpZb3y09ZXWvl3IEnl/PvOECdXuLkcRCKyRf9pa
	 Knr4lxm9X2/ZziKIjE+LsKu7ai1sEcwkMLIHh/1I=
Message-ID: <30b4137b-1445-49c0-bd1c-98dbac5d70f6@arm.com>
Date: Mon, 7 Sep 2026 12:58:22 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 22/45] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-23-steven.price@arm.com>
 <ap49Orng5-oehc6J@FCCLS0092175.localdomain> <86fqzl4biu.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86fqzl4biu.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/09/2026 11:10, Marc Zyngier wrote:
> On Mon, 07 Sep 2026 06:05:29 +0100,
> Kohei Enju <enju.kohei@fujitsu.com> wrote:
> 
> [...]
> 
>> Although the root cause is an RMM bug, should we also guard RIPAS_SET
>> against this no-progress case?
> 
> No. We really should *prevent* the kernel from using a known broken
> RMM. Which brings me to one of my long standing request: how to we
> enforce the minimum version of RMM that KVM is willing to work with?

(1) Do you mean the RMM ABI version ?
(2) Or the particular build version of a given RMM firmware 
implementation ?

As far as (1) is considered, the kernel already sticks to a single
version, v2.0 and doesn't support anything else. And we are fine with
KVM/Linux supporting a single version of RMM and deprecating the
support for older RMM versions as we decide to move on.

As for (2), the RMM ABI doesn't provide any information about the
build/fix version for a given implementation. I will raise this
within Arm.

Suzuki


> 
> We absolutely need to have a hard deprecation mechanism in place
> before day-1.
> 
> 	M.
> 

