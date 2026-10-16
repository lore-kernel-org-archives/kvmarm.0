Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E3A391E7C
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 12:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153506; cv=pass; b=UPOBmdDZqSh6vqGoZ2qV6Fjc/8T2BVfeNRcQITV8LOym00w99QfbYabnvtBpOawL/U9YEm1tpr8kwRM1SAbN3r8E9rMN41hyKSA8BFDn7lSAXN+5KJFtJxfEjkbxurnhH9OIXyxiiHvhuKB427ek2s9HB8rlyklhQTTCXtrEd8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153506; c=relaxed/simple;
	bh=HZbf0gFTkk4XHHbd0+91ej0u1COCP7IOH2nDV2cudv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GVDRBTrKsKBL1iB3wGM7iquxSPcxQM1l7qO83cCNItSr7WHSb2qUhi1hz3TK/YIaccvAsQncA9Igy3eiB3tEL0wXE2Ix+eeMmyvCGEGD73ksRVLKkmp671U9xWlvbPGyA070R8sFb3R2W6HNQ8vbNr55E1w9+rUloRYGB8jX630=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H/Z1lp0/; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H/Z1lp0/"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-888cbacf70eso69780347b3.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 05:25:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792153504; cv=none;
        d=google.com; s=arc-20260327;
        b=G76QPpzB76UDkUyZgL10vSPnA1q20X33prhD3RjBC5JW75FDDaMnB4xgth5ZoCXa5E
         O4Bfd57TB43s3NuGvySHAqS2GLQYDJ5JjYFjyZ+aqKQ9s3KC+jGhNXU74P06R6gO8Zch
         /rkPtuCSosTksLz6YHTRvUTGckfylUpyrUlqTVlH5Y8O8ofC837yVYRYaZS4Rg3K3u3v
         7loIR9p0/VIwH730mNyVUemdrAfbfg+6D3LXuxp7xKieElouXSPw7LYTgzadTRg/kOix
         /KWQdtlMo3tEV+ewmVi8VUhhPem3a0bL7cSmqUopdRQ6kxiK8/SkoDe9mEBB/uBYONgX
         SEvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zQ7v723Xwm8CKvdncmpgIg6KtAXzOUldqD/wPY6Bdsk=;
        fh=ti/kWWZyQWhtPP4K3xaX7y1xwpZsJ+x5xC/lyXraxyU=;
        b=Sdfpy/17TyXOest59v+AHDgZoDLKEm+epCY3NWV7w24iapgDrWyGFoslRK4aqbkp1h
         jWQ6g6qV/qoCzaRuEgeUFi7XYV3huaIkfq0Il1N2FKEOiS2iLOKuZeJznSQMBk6mDyJa
         vpNl8rjDJlFmPzX5ovY1ctIwnD6esHZx1gP75t161cDOPqEAsuO5laK7S8rkPqCIeYW/
         9v1kAAVk+TybvwPz+uMQEIX3NfXxrjI0JcAa01a7QneN5++v80sjeanx1VQ09wIgPbPh
         UnpPuLpl96Z39Kz/5SB/hJ9yUnpf6hgtjv4GninXbPiUlmRbbfUgMWXehJW+sSjETrK/
         kngg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792153504; x=1792758304; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zQ7v723Xwm8CKvdncmpgIg6KtAXzOUldqD/wPY6Bdsk=;
        b=H/Z1lp0/uBouuaZi4cbiNRuaIKZe7NdCeIxHCx2O5wY8c6b1yOnptO1a0R1pQrVoQP
         3ZFwJRx5c4YPp/KQBA9XL3zs5bV0rdteFBnA1DuXZi15cBsWPJMDkl3o7IMkdAijtQJB
         3ki0uBJbLKTcPV+zxmYQrVwLfYwFUEIkB4YIYgwM+jAbDSegh6EgtUPugrqA2gjCP097
         XIh/PHQlH+6imX85HXzPM9qjG4spqn9+UEhEIZiljsG2kwjeSVoN7YepDAhPIWk2MbFo
         VWVr8ZrMpHUYr+KyF89Ro9OJ2zmzmZQeFA7bp3sWc1OBfvMFE6ewx+tyD2/itS6fHhq1
         WqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792153504; x=1792758304;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zQ7v723Xwm8CKvdncmpgIg6KtAXzOUldqD/wPY6Bdsk=;
        b=aoe4cKakXb6+OKEG+6SQ5kuZkyjWd01VOz3MRrvSAvr7Wu3rrbJMTIfJ2yTHPz7Dp3
         R6Y1ZLEMJhIjcKJZmhOglYjTK8gIT4vfkiSAwto4cGDcCX6a6p0wkYp90SoYwyyWTRym
         A/hn9Es/QgSeKbKEinO8PkVCR6jEkJVjMNagUyX1qLR+cSdp6LJTUA1uV7klMOYBJvnq
         ckHMgMBo2OcolWn144OldmZlRsXDynsV0KbKZyEcbMGR/AcI81feEiBOMPTo1t+QjRo0
         cd02jdl2T6i7l3MLiXMjbedE0KlfLb4aGF7JXs2fmQLWEQ52IymS8XUCHpnljOjRtrBH
         1IZw==
X-Forwarded-Encrypted: i=1; AKwUvByTD+6gt9nxfmCOl9vTIYESY+xMSNxIeb7oHH9A6reRoQF0q0rWLm7TDQcBw0N5nCHz14RA7WI=@lists.linux.dev
X-Gm-Message-State: AFq9FYLXRVDQwRR1H8nQ0c8PxZ1OTQfxtq8nGjQn6eucvlaOyjpJnsdC
	II3cwt0YcgFurXC6IbLKf2FtHq2xVzRF2rG3nYV8hRSBhBz2BIOnTmwr2ZquR2gvzKMnRzYVypT
	JUwSArkcChLNBT88oms4AoSKc+3tOfUuCZt96pe2rMQ==
X-Gm-Gg: AYBFou0egx5UFzEE4K6QkoH68oxs2u4dXVmo7VIZxstkXAq8lBxONLBN3GRLm3gpZUW
	po9qqqIW42cVa8OV6Bp8fZ4pbePYHuovh+GIouwRvAGktFJj6tGHHPAqL071Bd5zX2+Byo/3Htd
	xB43hzd4dfZTFpzgOvOL8oxie4eA+bey/6IXekblw6HYZZimWA3gTPJCcj9ROogn0IVo9Tmdf53
	/K23LBpseHpE96VqG/35tzyk8If0RiBwYLkdD9mIV0XFqXoL2ZzcEbScCpK1nSuDZ6U+ndJ677P
	3i5fjvxP7NAhcp5PkaO5eam/vCYq/eM5L0xrFjmUizl1z4oonK99m9J3HRUn6CuEWhe6UcbfoCT
	vR8UIy5sMNFQPQlVml2lgDYji4bRpldpWLnJkejI=
X-Received: by 2002:a05:690c:38a:b0:8ab:f06b:4167 with SMTP id
 00721157ae682-8b07ed94faemr70880547b3.13.1792153503619; Fri, 16 Oct 2026
 05:25:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-13-khushit.shah@nutanix.com> <45c37754-2244-4336-9aa8-12d0b89840d4@redhat.com>
In-Reply-To: <45c37754-2244-4336-9aa8-12d0b89840d4@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 16 Oct 2026 13:24:52 +0100
X-Gm-Features: AclHuK8QUVErp647tqWp5ytpV4Of4NOKFC85jRCyp3SMOobKD0YHSCkB-sEVa48
Message-ID: <CAFEAcA_VksKhAoAFhV-F-DTdFTp02ZHs8cUrpX5qaOCAJTMOng@mail.gmail.com>
Subject: Re: [RFC PATCH v4 12/25] target/arm: add arm-v9.0-a-v1 named CPU model
To: eric.auger@redhat.com
Cc: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, cohuck@redhat.com, richard.henderson@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, berrange@redhat.com, 
	abologna@redhat.com, jdenemar@redhat.com, gshan@redhat.com, 
	skolothumtho@nvidia.com, sebott@redhat.com, armbru@redhat.com, 
	philmd@linaro.org, yangjinqian1@huawei.com, shaju.abraham@nutanix.com, 
	mark.caveayland@nutanix.com, ping@khushitshah.com, sandesh.patel@nutanix.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Oct 2026 at 13:07, Eric Auger <eric.auger@redhat.com> wrote:
>
> Hi Khushit,
>
> On 9/21/26 2:32 PM, Khushit Shah wrote:
> > Add a KVM-only named CPU model for the Armv9.0-A baseline, following
> > DDI0487 revision M.c. The property list is the architecture-mandated
> > ID-register field view.

> > +static const ArmModelPropValue arm_v9_0_a_v1_props[] = {
> > +    /* ID_AA64PFR0_EL1 */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL0", NUM, 1), /* only FEAT_AA64EL0 (Armv9.0) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL1", NUM, 1), /* only FEAT_AA64EL1 (Armv9.0) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 1), /* FEAT_RAS (Armv8.2) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_DIT", NUM, 1), /* FEAT_DIT (Armv8.4) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1), /* FEAT_CSV2 (Armv8.5) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1), /* FEAT_CSV3 (Armv8.5) */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1), /* FEAT_FP16 */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1), /* FEAT_FP16 */
> I have not found that FP+AdvSIMD (ie FEAT_FP16) were mandated by v9.0
> amybe you want this model to implement FP16 but it does not seems
> strictly mandated in v9.0
> so it might be distinguished from other settings that are truly mandated.

FP/AdvSIMD is one of those things that's technically optional (because
you might have some extremely-embedded special purpose device that
doesn't want FP) but in practice is mandatory. (The Arm ARM says
"This option [no FP] is licensed only for implementations targeting
specialized markets". Anything that might be running Linux and KVM
is not that.

> > +
> > +    /* ID_AA64PFR1_EL1 */
> > +    /* KVM zeroes out these field when MTE is not enabled. */
> > +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0),
> useless as default is 0, no?
> > +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_BT", NUM, 1), /* FEAT_BTI (Armv8.5) */
>
>
> > +
> > +    /* ID_AA64MMFR0_EL1 */
> > +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0xF), /* not mandatory */
> > +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0), /* 4K granular support */
> > +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 1), /* not mandatory */
> > +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 1), /* not mandatory */
> > +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 1), /* not mandatory */
> so the top comment, ie.
>
> +/* Arm-v9.0-a mandatory features. */
>
> should really be updated accordingly. None of that is mandated by v9.0
> spec, right?

The comments here are confusing, because what we really want to point
out here is that for these fields the "not implemented" value is not
always "0" (in some cases it's 0b1111 and in some 0b0001). Where we
set some non-0 value that is the "not implemented" value we should
say that.

Also, no particular granule size is mandatory; you just need to support
at least one, and 4K is most popular, but you can have just 16K or
just 64K if you want. So this is making an actual choice.

-- PMM
