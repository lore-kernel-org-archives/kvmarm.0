Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924487;
	b=b75Wz/mdAkGvKFRam3ASDbE0OgXCUQoa0DvJuYDrlLCT7P59pD7fIB0UNsIs/mrwoam2
	 yN0Te529OjPCMGCCXPIcuCo8sRH+QfnWDRmN/RJIpyATWYxk5otsiUsZ1LE4lyD23j3hZ
	 vq/JXtiSoHzdRrld+taXhZnejGmzXV8VLTo7+sqE1G+ejKM5Ppsd16xYQvuWVdp/aJcZW
	 rvIj2LiXMPbuWtgZKIxr27VpUTJ6IjNjlliMyKB0ZuC7ZAnj0dRUpPa3Dp8vR2T0X92W4
	 UdSBixeT7iDMDGtjElDsLhG1Aq12Q54ryj8MXAJ/l7Ow0t2RjiIFUMOSrI2vaOqphlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=htWpbWvWjkzp2iYbY9MWMmeINInucOJuS3Dv1JVxhx8=;
	b=vMa6HKhvb5e46bza6TIRmNdU/Ux4rUBM6Iv5kovrsjomRl8Hdzb4uYEx3LiD5W4TbNLj
	 7FKdayHZ35cYE23UZ1H7gJJqNvC810bdDlTM2It0I3fEbAXg3To0FFenJ3qR/NX25rxnO
	 I1+bslcVv0hBwqi2sDC9oSjniFwqmONn+wdlwu94elGJozkaq6xA0moMFxqGILcNjbRqG
	 KII9TlzqZgNQZOun3jzmUAn/A7EuhNaSF+2IKfmZFSNYanH3c7gYzbKoPpYWQVlCb2F7a
	 pjhtoucp2UmMxw8ftpP0zNdw+HrPvU1OCDjwYHonxDOMXlI45VNFFz+3rtsDNWKd0Jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bra1Tfpg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.54
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5482C606A323
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 14:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5482C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Bra1Tfpg
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so9367e87.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 06:08:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794924485; cv=none;
        d=google.com; s=arc-20260327;
        b=fZIrW/OEaUPlCLVxNIO5ln2GSWQawv/NBKE9Z4wG/hJS1lp7JGYoGNaBv/IlL+jTWs
         4xblZY1jjpOq5ImUqQTK+TePGMotmlo8Rz/q2Rq8teAy+fFPTDE/A63LD/FOhP/BZk43
         +kgnctGk6crLm7S8qdZI619sY3YMx8BEmx0aqYFe5DsCMYPpTHcXpuYhvbIBoQ/DW+aN
         mdbADzO+dA5xE6bOs7FpUldIyqRg33RYpccF66dZj2YgcuhluctKpMo9vsAwfplSrquV
         5/3SlV6+azB+47iF0EiN5LBlB1VbfkQ8CkO9sDWNeUQfj2xcM7x53Lq3W7wA/y/yBF4S
         k6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=htWpbWvWjkzp2iYbY9MWMmeINInucOJuS3Dv1JVxhx8=;
        fh=PtC77BTTnxZb6xf5lWfipjRFA2ocM6AZB/M/EIzdSyE=;
        b=FJuxRqkcJBWUJcuK5fCq/2QuvI2oICkA4KWeeH0t6sqfn7wRP04DhjWoQY7dlCshNm
         VKOPl161a+vpkojkvUab8AEv0miwjYFHjTBLaa4r8As8c+a0MJuvQzBGwzGhjdsRnVMW
         gdikd1QYsb3frHKaqb0MGnE4VGbm06NlO7Y0rbF8rzJpTU122aWvGu7z2kcdyLg+k/sF
         8FMR0p9H2f3ejrdALQX4nziZJfSYAasiWbe+/MyoZpYT8FiQQuHYLDc4x9JQF7D5mNZt
         jx41MZznDlGsjzpFKVUiXiTiSvRZ09Dvh8s4n9tRFtV7hquev/q7gFuyzYdjsLSu1rie
         1Igw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794924485; x=1795529285; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=htWpbWvWjkzp2iYbY9MWMmeINInucOJuS3Dv1JVxhx8=;
        b=Bra1TfpgF/h3uAt1nHVn0ghhaCuosHaQ14sCr0/E316wmmiMRzkc8Iqy0D5+RPQ7su
         00kG04zYfn872fBEY3vVZs2boAzMkygKk2isk+hYf/tg5V0xFJbpo3Ha2iPA/5auLzNq
         ythJWiw+IiKH4Be7/7WDcd+uWN1VxbPHjk3vAKKckrpo2BSPzMMkTFZuZfWFpTM06WBv
         4q9xkMadLycDiCt1L8CF3e5GoCaDCP8niGS1TIOLMVNuoV0AK/B/+jyJ9huuecVpMyT7
         I0uV2TRQBL7TDt8qrd7+HwKPcwnmga6B0mOA40Hzx8F7qeZ37DWMDIa882rw8xS1B9KG
         cplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794924485; x=1795529285;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=htWpbWvWjkzp2iYbY9MWMmeINInucOJuS3Dv1JVxhx8=;
        b=lQ5yswH68J1NcZ3tWBXkxzRph3zj8LcyL+MtK1ddaz2uZjNAUMwPu2uOg0shHqk/GL
         wOgxsMFKdOVqe7bsTpUUNcTqoGZulPQ0ia2poIApyHV4Mk5K1TSFuYfUgS5911kfJJYr
         SINOYcgcDTDFDkvkq2Fx5DT18CCFSjaoj/lhsl+ZLzxR1LR77Rr2mBf7xj9vaWK1NFqB
         U3THP0aTjmavXcU7hajZ/pdejDZt7oy9a3ybKYYbmMN+Q1OfMfr8zcNnXvzSKboPUVSb
         tAUoG/IxUXET0SG3Qjiq4UXfEZM97DUEsgHGla/9l7TnUb94n3pQ08lz75fxaP+XNwIj
         2L6g==
X-Forwarded-Encrypted: i=1; AL+hErGas3P82eYU5qHVsa3Pe0QFlZ1bJscv/CjjIIL1Ya0yvlAC7zWuZ0gOPxtwiaZnYiCAErSSdog=@lists.linux.dev
X-Gm-Message-State: APuU4Z8YqAXdI/JG7KzoY8YI2JnJJFbefmWtpQs4vv8TkFIyIe4gtjyr
	CjnIqai4BgO40f9Iq9r7P1yYH5c7/o4TH54KspmiUXIlbam0fFUprWC14vQZQQL5QTmtpoUXYal
	yQSod6wG2V2HE0riFscyr87rsn9yuSYKRVonEqFR3
X-Gm-Gg: AYBFou0/W/BBKXV84BXZGxKeTDnp7ALqYrlbUP4oQn5rOxW5hHhF9ByL9emoQ0Ia/4Y
	gAZsU74YKAaf2SOtIlr1y01qSQLzsKNZSjN7Y/GKkn04lp/ktuSTi4Hg5of2utaa0MztqsXY1qx
	B1wxPDW/tPPxZn6Ni3U4bIQP+Gu+9eip/x3lF+Q3sHlXH3fwrPmCoB8zJ4KcPrEKnIjCYKa2GDy
	meUQMpsi+TkAbma5kYDishrljHvLTSGespbXo+pUs7wfEoEgTZzqGRbzlB+vHdAN+0jPveqoISY
	2elJpDPZNRl/YQBZfR0PwgtIzoycyEcnzA1h/Xv/1HAtJyA0cYqx/bQMw+c44DSHxLKgKij1n9m
	eHA01x9hAKIw+CQd6fX+Wb7yVE4QoPmEl9BVyVZLpFdaexEgK2emmOjQYiTsGRZTxH2YOIBF8Rq
	rhCM0kUo84HN91iww1jYllwaM=
X-Received: by 2002:ac2:4e07:0:b0:5bf:f84f:1d74 with SMTP id
 2adb3069b0e04-5c1a2185fadmr137629e87.13.1794924484857; Tue, 17 Nov 2026
 06:08:04 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116164358.142785-1-steven.price@arm.com> <20261116164358.142785-3-steven.price@arm.com>
In-Reply-To: <20261116164358.142785-3-steven.price@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Nov 2026 14:07:28 +0000
X-Gm-Features: AclHuK_JC9RetKL5Q3HHKVX6R6ajyHm2xDLO6StGpKQMwUtLiIUPvzFbgoEna3U
Message-ID: <CA+EHjTwfp8p7uwP2LXEqSmTwL6ZHuDCYbvMie_Wr_30xJwfO6A@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] KVM: arm64: CCA: Introduce Realms
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Kohei Enju <enju.kohei@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 16:43:48 +0000, Steven Price <steven.price@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
> @@ -1571,31 +1576,39 @@ struct kvm *kvm_arch_alloc_vm(void);
>
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>
> -#ifdef __KVM_NVHE_HYPERVISOR__
> +#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>
> -#define kvm_vm_is_protected(kvm)                        \
> -        (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> +#ifdef __KVM_NVHE_HYPERVISOR__
>  /*
>   * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
>   * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
> - * which is populated correctly and is gated on is_protected_kvm_enabled().
> + * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
> + * gated on is_protected_kvm_enabled().
>   */
> -#define vcpu_is_protected(vcpu)                                                \
> +#define vcpu_is_protected(vcpu)                BUILD_BUG_ON(1)
> +#else
> +#define vcpu_is_protected(vcpu)                kvm_vm_is_protected((vcpu)->kvm)
> +#endif
> +
> +#define kvm_vm_is_protected_pkvm(kvm)                                        \
> +        (is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
> +
> +/*
> + * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
> + * make sure the vcpu->kvm is always valid VA in the context
> + */
> +#define vcpu_is_protected_pkvm(vcpu)                                        \
>          ({                                                                \
>                  struct kvm *__kvm = READ_ONCE((vcpu)->kvm);                \
>                                                                          \
> -                (__kvm && kvm_vm_is_protected(__kvm));                        \
> +                (__kvm && kvm_vm_is_protected_pkvm(__kvm));                \
>          })
>
> -#else
> -
> -#define kvm_vm_is_protected(kvm)        ((kvm)->arch.vm_flavor >= __VM_PROTECTED)
> -#define vcpu_is_protected(vcpu)                kvm_vm_is_protected((vcpu)->kvm)

This brings back the _pkvm variants that Marc asked to drop in the
plumbing series [1]. In the nVHE hyp code, kvm_vm_is_protected() and
vcpu_is_protected() already mean pKVM-protected, so I think the hyp
side can stay as it is.

At EL1, the pKVM-only checks that a Realm vCPU also reaches are in
kvm_arm_vcpu_power_off() and kvm_psci_vcpu_on(). Could they check
vm_flavor == VM_PROTECTED_PKVM directly?

> +#define kvm_vm_is_realm(kvm)                ((kvm)->arch.vm_flavor == VM_REALM)
> +#define vcpu_is_rec(vcpu)                kvm_vm_is_realm((vcpu)->kvm)

vcpu_is_rec() isn't used anywhere in this series. Could it be dropped?

[...]
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
[...]
> @@ -906,7 +907,8 @@ static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
>  /* Only the guest's CPU_ON may start a vCPU EL2 holds powered off. */
>  bool kvm_pkvm_vcpu_is_powered_off(struct kvm_vcpu *vcpu)
>  {
> -        return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;
> +        return vcpu_is_protected_pkvm(vcpu) &&
> +                READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_UNINITIALIZED;

Only a pVM's vCPU can be in KVM_MP_STATE_UNINITIALIZED, so is this needed?

Cheers,
/fuad

[1] https://lore.kernel.org/all/86pkxs2npx.wl-maz@kernel.org/
