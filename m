Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DEF46EC86;
	Mon, 14 Sep 2026 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387457; cv=none; b=ARsb/Q/Gv3wLXAq7lggg0QZhLysTihCIwjGIewI9bwfvVl3LFLBVtGcj6cErEUkD4/MeS7VZ7A9JYIjiNaaSSNyvrNkr5iM1Ms0DtZejk3hQDVAVMbIm+VJRIGt9AeMARsJWNCcp1HlX8tb0uDj+m9Y2763bWXFV1mEPed7HrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387457; c=relaxed/simple;
	bh=F53OZhFkUab24xX0buEm3kIAACPTXkMQuVJTXFN7YAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jk3vK5Xb7O2u0v8kullL1UlSssDlWxCvL0l9/LTJt+I9O0PT01N91ssODXfzjxGrkZsUkUMjvkNh7XLg7fPxDR1zcagXFdaLsGVrJFmjXouZtrVwPqrfbuJoM48hiU7ouZta+GzEd2LgChbLaUFH1O507qDVlEXZhYgoEBOeOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUxLR/Xw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUxLR/Xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C341F00893;
	Mon, 14 Sep 2026 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387455;
	bh=sMpwNCN/PilYOizsb4vbTSRly0vNd+P9tAq4T5tOvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUxLR/XwBZ8wNJtCuQH3h1F+HL5DxMocu6uC2lWGnqbHe6TO4yYQnlbTcF2WGBKNM
	 mmd/YztTKVcxrI88onZHwERLpzBdOrsfZSCkKmJmlyXEH7CxJ2T9G7PBPqlq1fCm+k
	 UGK1WBt/woedV61WjppbviNQA7+SaVvCIuzL5bESHxo5sBdFUCHzjV3/n/RI6synyF
	 yvwkoERzCX5y7DTHfgb0AkAmvQjElDiOp5jIacg7REOSYf5xwkSZ1ILzQyEdqKx6DM
	 e5CnaxhKUi6kBJyILesWLDFygsFNxFxbeISAe9+VV5I/lhKnqfpKNSxen0F38v0e2A
	 JFJe7y3QKJNHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Px-00000008bEf-39VU;
	Mon, 14 Sep 2026 12:04:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Tharit Tangkijwanichakul <tharitt97@gmail.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	Gokul K <gokul02k@gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix VM leak in early return
Date: Mon, 14 Sep 2026 13:04:12 +0100
Message-ID: <178938739499.3215146.16232496567237748545.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906034144.14059-1-tharitt97@gmail.com>
References: <20260906034144.14059-1-tharitt97@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, pbonzini@redhat.com, shuah@kernel.org, tharitt97@gmail.com, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seanjc@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, me@brighamcampbell.com, jkoolstra@xs4all.nl, gokul02k@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 06 Sep 2026 03:41:43 +0000, Tharit Tangkijwanichakul wrote:
> test_mmio_ease() returns early and skips the call to kvm_vm_free() when
> ID_AA64PFR1_EL1 is not available.
> 
> Use a goto so that the early return joins the common exit path.

Applied to next, thanks!

[1/1] KVM: selftests: Fix VM leak in early return
      commit: bb6c7d2bf564cdaa24b14764b7126f5cab45965a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


