Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0D0382373
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786035392; cv=pass; b=K1auAGrzbmxifMPcpH9ifkjnsXQtBhcd0J37BHwFv47twrVaaGRu2uFrMJaHFi1L0vKgYNNKYpH1GekRuTkJaou/ZTFfHTGkLGKWkd3zCcffspP4YlXPVdLnoHb/9RZvOSmaGLrdW2tBr+3sdseWe82OVnJ7r9PQnyVhULNcibw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786035392; c=relaxed/simple;
	bh=f+ufcwVAGvb9W9isCqFkc/i9D8VDCkCbn5l0jlZX5Ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=quKk0KRJeqriGPpHhaTXHhpeHfb76UN8SamVGlP6yAPjhu9hoZBoKLH0N4Ka4p7M28ex7aocuqNvdJ2F0xLvI9m0zL8GY0cMspbXA6KkrNAJUAJla4rWb+TMpH/e7ZCH3BlQESdPazWBZACCyr/1iZfzN4DtdFzoAXprHnRoQEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AIEMwhRk; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AIEMwhRk"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c10e86e52so2251cf.1
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 09:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786035388; cv=none;
        d=google.com; s=arc-20260327;
        b=iiI4AByQgQNG1aShdKgilmnSjea0bN1Eg7qscxDTnU9Bkm+E69NrjosDmXME3XCh23
         OBOf2dHp4OsGttSvXa6+1RUJ4Nv2R6jnlF5pBBLD6XcGKgSUc9tPkGyEoqi0HvMRVsLc
         uOeBflPrcR4/Y9GRUdl9H87355HXdRtHqQMfIhjoOrajmkElgNo9dSABUQypXWA9oAd3
         ftDqvK7rnUP7aVaVP4l2kELmVCgejvc0G6SkiLa6Khdt+9HzIMERwLufdEwQi1BM/uoW
         IR37yDniLXbdjN5Z1m21wrysuXjYvroEJUDiT42kwNF0u4grTYa+dwRraAe1Frc4HuzY
         mgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gmc94BOeV/agrYVwd5GE2jTgxobDY3nBhtv7wGNzmI0=;
        fh=ZB3ZwHZOAWCiw9k7T4jzVfkP+ZC5HridA/RVzzqO1J4=;
        b=mo3ShaqeaH7FVCfy59nmukB4GscBD4LptHQv3iCNirvqeCS0bx3aJwAV02koQQZzRH
         aoGvNHYQrhXXIHvr3rycFErqEIsYVRyPiCPxSE71gsiRiUF1/nC1i7CigJvcbB2lmFt7
         LVV22XVt32qoCpm0Md7wCcZasHZyQOB2S8kGRJMANvvM4TfMbGcjYK/L7RCFEp8JUKgD
         1ExYpXqR5kun8Zi/aNd23yFkrXJmAsSWfnnjTnQrjzTa03tzfKXyCBY2T5Paq8yxtBz5
         vGbIuY7bycNcSPCr5yhByt8KHNaE7eyrC4kPzesa5weenUqEmjnlyWhdlV8PX3CB42FT
         kttQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786035388; x=1786640188; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gmc94BOeV/agrYVwd5GE2jTgxobDY3nBhtv7wGNzmI0=;
        b=AIEMwhRkTwQy3xGGSWwc01QFfsgGkpurdAI4+6NfJkk8espryGsI8QI4yYhG2FZe7Z
         zOp9kauXefJ0rbA/FT09Bi8glGVNQl75mlZ1xVgkAlYufJ2G0x9Ap1v1ElHl7Nf5FkIB
         h4G8b0vI5VL6KXtITLeG8xHce5psGOxneIrnFihDEo3rc4Ir0sw9IPo8QpAOpjSLoOR1
         +8inNp3Xv+TqEAYqkaUtSTS+DVbUo2jLZ8fwVkff7hV3u4FP20ynDJ6vnJ/pYtjhY29r
         FfE49R4ZjjijavtSpdx2o6h3IDzQByVfNHs/STOpeUNdiSzwtYA73rzk1MFy34jltyRS
         p4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786035388; x=1786640188;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gmc94BOeV/agrYVwd5GE2jTgxobDY3nBhtv7wGNzmI0=;
        b=WIfpyfY2Lu5PcoYNy1A8IlJjtpU+L2pXYNnYAGMP0UbMFlXlMNgER+wREdg0oQyg5A
         IeNn3j99lIwxzGFrKi4C+R2s0mPRYgt+wtRoyglQ7bfFiOlDQuoxuIzg26b709T3gA9k
         mutSSyzzLSRklJt8IGAbevDKXE9TWu2XosgjKU60RNWWn7o/jVTPzZUz+ZYv6qNhIM0/
         CT2LxFkqUjpqC9t0dPkO4XApY5slrB0G9+DA8IvpvxkufdN5AMlWRX5woh9snpuXPS8c
         wjbmazyyJT2h/4VBfLSOvjgkf2Nh4ArJyP532qozQW9JHJaAuKCBZyNXpvyQlpmzI4WZ
         N/qg==
X-Forwarded-Encrypted: i=1; AHgh+RqIWAk9qMmV2aHoRXRqyIpBqPBQFvivyWSSqCrDcgH6r6JtK0o56DfAqKMaiycOf3EQHfVXw7E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQpvM50CQu5I6zBZSJu99mrzWGeWRJow0fP2PnhWiO8UtBGzf0
	7BlFV6tmFM1LLFgQLI8iL2u2O3dPykZzk2cn9HoTyKuvfmMtfQxFdC1O0vKGIUjNrWKctn0ZvVd
	VkZ5b0GMD8eejMAnfZtCgQcKBYAeF/VH+ok3v3wb1
X-Gm-Gg: AR+sD11OPmm8AjlABPS0ypIRkkjvuoHn/vrhHNHF0lWoVlHUPs61XBjwjE3eardg7ys
	gLpuw84uzL8NOVWz1/beb6f0VDsyYfBPS9Qkuz6GJAf4di58bXZP/TEB+1G7eiSs0oZ0ChBX2Mp
	m/h59nYvvHBU8E9HlFg1ww4DB8wim26Dwe4DFaxpcl3SmJHMpYu116RFqE87thxLrLfAwOImt9P
	l4TvN+VMWPL2ANEUxOgp1jVFAbyNs4AooqkcNu9jiWpDr3QEIEozVGLi3QvD2bCc2uem8CVoC7Q
	cteSwWRYkdNzISVJ4zXkPgJoNJRhDjyiMpxP7XqrwKCAA7hbVsMI+jA=
X-Received: by 2002:a05:622a:aa06:10b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-52cfea3217fmr17874811cf.9.1786035387706; Thu, 06 Aug 2026
 09:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806150105.4010701-1-smostafa@google.com>
In-Reply-To: <20260806150105.4010701-1-smostafa@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Aug 2026 17:55:50 +0100
X-Gm-Features: AUfX_mwomSdWQ7tiQrgFTXXCNg9udOM-KnUsiS7N6B9mS0wCaSf-yQZNn_iicSE
Message-ID: <CA+EHjTzk154LY4Tb8mKCL5iud23M_VovoRAujkr6qOqEc4_rWg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix hvhe and broken CNTVOFF_EL2
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, maz@kernel.org, oupton@kernel.org, 
	seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Mostafa,

On Thu, 6 Aug 2026 at 16:01, Mostafa Saleh <smostafa@google.com> wrote:
...
>  void __kvm_timer_set_cntvoff(u64 cntvoff)
>  {
> @@ -63,7 +64,7 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
>          * Trap the virtual counter/timer if we have a broken cntvoff
>          * implementation.
>          */
> -       if (has_broken_cntvoff())
> +       if (has_broken_cntvoff() && hyp_timer_get_offset(vcpu_vtimer(vcpu)))
>                 set |= CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT;

nit: the comment above could note the trap is now gated on a non-zero
virtual offset, to match timer_set_traps() on the VHE side (well...
maybe you don't want to _completely_ match _that_ comment, but you get
my drift ;)) .

Tested on QEMU with a forced has_broken_cntvoff(), then booted a
protected guest: without the patch it hits the UNDEF, with it the
guest boots.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


>
>         sysreg_clear_set(cnthctl_el2, clr, set);
> --
> 2.55.0.654.g21b8a5bc05-goog
>
