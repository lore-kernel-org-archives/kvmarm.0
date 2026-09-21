Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70DF3BBFAF
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975541; cv=none; b=cTNvDy2eCWQ6vzpRIFalNgKAzaR2Y3TFYOXtXObaC6uPOJiDPXPnEsdQhC8v+MeCTZA53XBNEnbgW2U18mAbAQcbVYuOENMPwHe+Nj8IPFMJ+0C1PkgQFlk+cxQrt6NIBpz0jpCDTD9y0AMDZ808/nrSkFppgaDaMWYlBEngR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975541; c=relaxed/simple;
	bh=SahGD8wStb0BEVF7yvvFemwPhMiROYcEgpClXUQfv20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0snKeHZ+2EJF0IwjCsd7xR3WqGEmkOspi6V1IOL2sip9f1dkx44vsjqG6213d41tSk+n4GgrmJekv5cQkAHTbP+lGWhav6Jx2hrs02LPOwJ+sr++2RWZpMlFAFdK5yfqc/hU9Vu+c8/QjU7xrcynJpdFIuFBiQ3aozsxlvkfnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kx/VTCNH; arc=none smtp.client-ip=91.218.175.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kx/VTCNH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SahGD8wStb0BEVF7yvvFemwPhMiROYcEgpClXUQfv20=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975533; v=1; x=1790580333;
 b=kx/VTCNHd/zi1T33NdhUfct/g32mD02vx3b46p+1h0pvNDrOhLAMMr0+q9L4EyMJmHhlaL+f
 jM7i9mP56+UdCdFD+in1Z1/hzzp1AxvsWURMXYB6HQEadO5ZsGLsUadoJK7DmalTJZ4Lj8Xe7FT
 Uqxj2LaZ+g1bnau3NIMN2thc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 701c831f807fab62;
	Mon, 21 Sep 2026 07:25:33 +0000
X-Mizu-Trace-ID: 701c831f807fab62
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b8c42da963so7505e87.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 00:25:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz/HtCUnNJLbOwcTqpUWobN0lPLq37SCkDbhq0raaK1a9f94IKmJIcPBZHpxjOOn4y0XA5jiVE=@lists.linux.dev
X-Gm-Message-State: AFuF++nsPf/zz0lt3hdPdxHroyvxFPtta5MMqXbgm+9gXwm0BkBLMmex
	qpZuW+tK1eyQ0qbnCx0/pb0ZRu4pv4/p73ddMpoRvks3WaKKWDqOSsSRl0+YlQq804Bkk/DEzTD
	12brnCfYVMeYO11bnBU8rUeh2f4KtEKjxx2hCrSfJ
X-Received: by 2002:a05:6512:10cd:b0:5b4:9dba:7403 with SMTP id
 2adb3069b0e04-5b8c7eaef8bmr111208e87.13.1789975532579; Mon, 21 Sep 2026
 00:25:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260921063718.1604533-1-fuad.tabba@linux.dev> <arDYHSlFHm_XzGvN@kernel.org>
In-Reply-To: <arDYHSlFHm_XzGvN@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 21 Sep 2026 08:24:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>
X-Gm-Features: AcwNN1VMg6PbfnlRIzn1fjVR1-_CkT5UjrC7WdHauJujyrzeyYN_lrO0wc8jZWk
Message-ID: <CA+EHjTz0-qS8RRhdT8XjAgWqKhgjjzbRsZ_jwTBVqM-8pXk7Vw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Restore the VM's feature bitmap when
 kvm_setup_vcpu() fails
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Jack Thomson <jackabt@amazon.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 21 Sep 2026 00:09:17 -0700, Oliver Upton <oupton@kernel.org> wrote:
[...]
> > Nothing in the tree loads a vCPU whose init failed, so this is latent.
> > The upcoming series that enables KVM_PRE_FAULT_MEMORY for arm64 exposes
> > it: the generic kvm_vcpu_pre_fault_memory() calls vcpu_load() whether
> > or not the vCPU has been initialised.
>
> That's a bug, not a feature. We should require an initialized vcpu for
> the ioctl.

That one is for Lorenzo then :) I'll reword the message so the stale
bitmap comes first and the pre-fault crash is just how it showed up.

[...]
> The bitmap copy is a bit confusing because there's only two possible
> situations:
>
>  - KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is unset and the bitmap was
>    previously zero
>
>  - KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED is set and @init->features is
>    identical to vcpu_features (see kvm_vcpu_init_changed())
>
> While there's nothing wrong with your diff, I'd prefer if the above
> detail was represented directly.
>
>         ret = kvm_setup_vcpu(vcpu);
>         if (ret) {
>                 /*
>                  * Clear the bitmap if setup fails on the first vCPU to be
>                  * initialized.
>                  */
>                 if (!test_bit(KVM_ARCH_FLAG_VCPU_FEATURES_CONFIGURED, &kvm->arch.flags))
>                         bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>
>                 goto out_unlock;
>         }

I'd gone for the restore so the failure path didn't depend on the
flag, but those two states are all there is and your version makes
that explicit. I'll use it in v3.

Thanks,
/fuad
