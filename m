Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC232D2382
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367547; cv=none; b=cod/kJU9D941X2nNQYkufanDW8H73xLdGCqqdFkaCmLLzpJRK/giwVCxGJuabxMP9ysL9WUDxtB3O/aUvUAsMSNTrrbCwqQPTay3QqE7Hm6K9SI8aQ4/iqqEdR/JT4t4E47IMDrspXZppDBHMsniQtSJ9kQ8vmWdGD6RV4kTYgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367547; c=relaxed/simple;
	bh=u0xDEdzgIvp1jXjtMCIvp5g1TCOxOf/z9+CMM5yvNJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UF+d4SB95YSuynY/uHh/luadLIvDK51jaodrLAL4iChx3QWVeBksxfPoZzqOkcNXSeQCVB64BQI671bx9cxP9VFMk/3weS7gD2AWuPhN1NWW6NHJ9L/L13k7q5KAP7wsiBd4gOo8XEHR1d2Sumr6QEpVg7lxxGBxAX+WF6zNpvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TASWVwSN; arc=none smtp.client-ip=91.218.175.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TASWVwSN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=u0xDEdzgIvp1jXjtMCIvp5g1TCOxOf/z9+CMM5yvNJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789367543; v=1; x=1789972343;
 b=TASWVwSNKO3PxpZAi1h5mnCj0VYQ7ORaEERy+Rmnxv6YEtlO032d/XEyCCRSPYClOsXDmi0z
 FvgypBfky1x6i1RFIHRuclLOsntaGhgYBf+iDfn3Mchgtde67x0WZ+W8OYgFkboWdSygqbHKWEe
 JwPhVeMVJFBrCU9wHB8oXoEc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a99a44255697f6c6;
	Mon, 14 Sep 2026 06:32:23 +0000
X-Mizu-Trace-ID: a99a44255697f6c6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so5004e87.1
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:32:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBykiENU175ZZmcnYl+z7whZ7WcK/VOtlDWRmEkeZBatS+ZvB95zqLvACFcWp5pbz5wKHHx+k+0=@lists.linux.dev
X-Gm-Message-State: AFuF++mZ8wkjKCkZZ8EvA/hoDTE7+9qm1qO62+duUKPMIyHwsBpdcc53
	JIgZjDMDGIf7XT5au8qNFuMUbGwgR75PoBRhL22YtH/ix0CEdeIszF35+lFU3Q6QSrkb5OjERWU
	sgyc1oD71jndhG/QzqOeSCv5fu5gpGmtWmlqQP0TS
X-Received: by 2002:a05:6512:3e0e:b0:5b8:9e63:dfb9 with SMTP id
 2adb3069b0e04-5b8ae42ae97mr21520e87.0.1789367538566; Sun, 13 Sep 2026
 23:32:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-15-fuad.tabba@linux.dev> <86jyos6j2o.wl-maz@kernel.org>
In-Reply-To: <86jyos6j2o.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 07:32:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwL4dUC6_ok+OE=zhFK_Dhosc1Nji4Vp4hr+HYibF6cgQ@mail.gmail.com>
X-Gm-Features: AcwNN1V3-IRZLy4EhuEzKp1SiumXuAoMIBvvNz1M8aC8VCuBKY3hnZnOfpboMkk
Message-ID: <CA+EHjTwL4dUC6_ok+OE=zhFK_Dhosc1Nji4Vp4hr+HYibF6cgQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/17] KVM: arm64: Reject host access to protected VM
 private state
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 11 Sept 2026 at 13:58, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Why can't these be moved to the ioctl callback? Something like:
>
[...]
> +static long pkvm_filter_vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned int ioctl)
[...]

Much nicer, I'll move the three has-run checks into that filter for
v3. I think we need the other two where they are, though: the
ext_dabt_pending check reads the payload, and KVM_SET_GUEST_DEBUG has
its own case in kvm_vcpu_ioctl(), so it never gets as far as
kvm_arch_vcpu_ioctl().

> Where is KVM_CAP_ARM_INJECT_EXT_DABT rejected?

In kvm_pkvm_ext_allowed(): on a protected VM it returns false for any
capability it doesn't list, and patch 16 doesn't add this one, so
KVM_CHECK_EXTENSION on the VM fd returns 0 for it (and for
KVM_CAP_SET_GUEST_DEBUG). I'd keep the ioctl check too, for the VMM
that doesn't ask, since userspace has been known to act silly. I'll
say so in the commit message and in pkvm.rst (maybe not the silly
part).

Thanks,
/fuad
