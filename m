Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9165D4E77EE
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614662; cv=none; b=UObESN2U9d+Q6TMOlAJv44KvyLBdK7VcZ7ddIU9VVs7zULRXa+nSniyCd+9ztuSyltrpn0PFwLclIMXxZmbJo1JuVX7iKvyV4OqrCMTXDZT+8FYpaIxhmRVUFc79pVIR4hD18JtBlbVkXU3xiYr67gIGqy6OuaopoyDj89wtRpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614662; c=relaxed/simple;
	bh=n/OY102PNQOkr+cQRPgs6kcL1DdXHbQTCuyeQ/Mtw1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWZeI3Pwhd3SZmXwTCiKsvXJZfSasaQhH20WIlclmHA20bZzfoOKH7O8eAhJdIExagVOP33SRDGzWpwzLTQhn+umlIm0kGvQd5O5YTiWAtymCq5QKdZNOFontUNyUdBARRtiwgTSdsRY5prJLaeac5REkrGlZTwpmsVeYa98P2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmkelVyz; arc=none smtp.client-ip=91.218.175.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmkelVyz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=n/OY102PNQOkr+cQRPgs6kcL1DdXHbQTCuyeQ/Mtw1c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790614656; v=1; x=1791219456;
 b=JmkelVyzxQlp4zKW/UijXHNyA3c2XOgcuTyhSE632xxEa9rYX1kK8HWXGLiigmAgRQn9b56W
 mgGusNL06FrOPKKR8ayl8sVP3G6sZ/KDXRs7dRbSXXlSAnEgQkvvrPUsX+KNP/fPaM+btj3mL+S
 +v2GBDoMR7exyqWJ1FkJLP8c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fd69fa683b8212c4;
	Mon, 28 Sep 2026 16:57:36 +0000
X-Mizu-Trace-ID: fd69fa683b8212c4
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b8ea0ca5baso262e87.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:57:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzXg7OmfZIgcASKIDjj3Sn7Xa0y5ZjP7nB8FLfC1g9UutHcLnD7x89izgsQxLPlICbq9xSVuTQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYLjj0YOjoEEI3/hMzPGVf7vzYuZHWt1NubnlMSVrvziw0FGlMMB
	zoJT8ULNl3scx76o0F6CQOpaMB9aJihu12UxPFDvLEEyfp9VYJn7bwM2Ce7mQfBQCQq5w3hTwsz
	R/Y1EwqKzyMhYuSVpeLbsmabkXpSoK27e1cji4e1L
X-Received: by 2002:a05:6512:10cd:b0:5b8:c95d:529c with SMTP id
 2adb3069b0e04-5b8ef0ddd19mr213006e87.0.1790614651041; Mon, 28 Sep 2026
 09:57:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
 <20260901-kvm-arm64-idreg-final-v3-3-a0ffa06fa872@kernel.org> <arp7mig_PrD9Jbc7@gremlin>
In-Reply-To: <arp7mig_PrD9Jbc7@gremlin>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 17:56:54 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxi=BrJYMb5z9QyGd7k_Ty7x5AbMNJinB5i8GT=BD2L_w@mail.gmail.com>
X-Gm-Features: AclHuK_NPvCKoTUsp1F5W2JZ-hpSJQcM6rQqImNAWwVW-ibb3CFddo_4yf4cCdI
Message-ID: <CA+EHjTxi=BrJYMb5z9QyGd7k_Ty7x5AbMNJinB5i8GT=BD2L_w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] KVM: arm64: selftests: Check ID regs are immutable
 after a failed run
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Peter Maydell <peter.maydell@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Mon, 28 Sep 2026 15:46:51 +0100, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
> On Tue, Sep 01, 2026 at 07:18:50PM +0100, Mark Brown wrote:
[...]
> > Assisted-by: Antigravity:gemini-3.1-pro
>
> NIT: we changed the rules for the Assisted-by tag, it only needs to be
> 'Assisted-by: LLM' now. Not a huge big deal but FYI :>)
>
> https://docs.kernel.org/process/coding-assistants.html

That tag dates from way back when the format was still
AGENT_NAME:MODEL_VERSION :)

[...]
> > diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
[...]
> > +static void test_idreg_frozen_after_failed_run(void)
[...]
> > +        /* Creating an in-kernel irqchip would change the ID registers too. */
> > +        if (kvm_supports_vgic_v3()) {
> > +                r = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
> > +                TEST_ASSERT(r < 0 && errno == EBUSY,
> > +                            "vGIC creation after failed first run: r=%d errno=%d",
> > +                            r, errno);
>
> I guess in general it's making sure - where there should now be finalisation on
> reg setting that this is actually enforced?

Yes. The test exercises each of the userspace-facing checks that 2/3
moves to KVM_ARCH_FLAG_ID_REGS_FINAL: set_id_reg(), set_imp_id_reg()
and kvm_vgic_create().

Thanks,
/fuad
