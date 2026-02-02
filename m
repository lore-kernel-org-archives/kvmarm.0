Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7B8360742
	for <kvmarm@lists.linux.dev>; Mon,  2 Feb 2026 14:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770044135; cv=pass; b=tx0X0XMaJFSMlU+xKOn5hdt4iY2FuJ76mcGu+2lUZV1+wZRJ3BtnldhmBpmf3DI0xlTAmBsU2yFLGm+/NFQ6yRyeu4hu0XZQXvfdFZaQNjvxRkm6ln2b5bZY6Qejk4GsTQKZhpN6Sr5oIL0sDk5bmC9hdC4m70M9CH7cD91zHAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770044135; c=relaxed/simple;
	bh=L+Drc4zZELrb56o4CSDEnC33mSxORpzl59/bTQk9IrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nMJ6qYYBgmfCnkc/19OLlN4yqhftsmmGlvDydYMBsZan2p1VYw8pTupGDLL2nxTmp7w3qKKhwFgd7rAfI8X+oIqk86buILt48ITXEaSGCS81cfTQuArb7wDdQ4QQhOLstOWe4/fXWeakAJjf6vAscgo/R4kFRga67FmqAe0fRBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bba2ExdQ; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bba2ExdQ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50299648ae9so1132661cf.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Feb 2026 06:55:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770044132; cv=none;
        d=google.com; s=arc-20240605;
        b=fern2Vcyjg1+RCMKmBT+NpwK5S1UF1na2N3lsPr5DqRgGdw7UoeqRMxT7aKQFbGVQK
         pQlCr8J6orEhO6SZcDcIYnZcwxnMaItyHVmp0uHtPDwDQgp8mrEa6QeQXb/mIF7H5zaL
         J8LJWKVoop7O8KBqazJZGI7s6/GzM7ay8/p+mOsAM7php0DeJScH5/k38Ma6fFbl7873
         ide1WHOTOJuF+9N0Kpe2q25YHxRybEhBF169vQ/3MyK8a13AZlaZERXIv7Iwn97lTA69
         4pu9VKYtPpFedVrEwug/Y47T4x2zyeWHEFKrTsLVcr0rPEUO8eEYtxvpPXZr3+LLOkYI
         Puww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        fh=GURHi+QUdrVR0x2HGpkPsVqCO/EHqUYh0xJqjKPtsC8=;
        b=V2o9qaUfF0sM+MbwiQxeXvJh/10PTnXAeiskedR8LaUKSk53be22dShP//Q6l1l51d
         DNi8uJAIJ7SOlj74jBkIJ2cblZSz6CMhaCJSs5PIGTawRtqbkICPzekztzA8PjrlbtLO
         61i7lohuAXZPmyCksymjbPLL8eeNNfOUKtsfdg2ozI5wN1voOYEJAzXv2s2AlJ49FDk/
         ip62xDqJURrj0xaEgYBROO67v1OVrMLq0R1b/DnbbPcNmk25oJE3ImRi+7M4gIlNka4l
         9offPEBARUbm/LxmMA1lrSBaQ8mzVyVbZU1hEe1FwyWX6CQArh2TYxL/4DjRctyE5M0u
         /FbQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770044132; x=1770648932; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        b=bba2ExdQUiURxdfKvCp9mHrIGSBftXszEHrxnsdmrEX/H6l76Mlbn27ATIPxo/CXLg
         k6xXjv3NrEwaPVD41eTBjOTi5eqJBtCrftr6sm8FJP3DCOmvNJHbAMdWkK6OLj6wroac
         xYUfjQYs41ohxgDpd2X2OZ8MuNB18KEUd2tLFa3OKwiSqk7VvqVk4BGIb7DIkp6shGUp
         5B53A9kSJjX9CMtdPjiiK6m9cSbk0qk65268xfVdjETYoLJMjPYL+td/OAvwTa7x5OiV
         M1nqK0dVIWfAPkNjmQR25SsrWChL3k6wmaSnW6Ml8sHdBjvpdvSR3IAFKhEoUppku8WX
         VphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770044132; x=1770648932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p2kyDBMjKUAvLcpywCWxpjEa8MLWup/GMgXHmqrdgQw=;
        b=ZePZgFxukCzB8PZbpfgfnZneZ+OOPZrFUSFE+jWWgFnTq4hglc6YcWr72vzm40xbuU
         WTCXDRCX2XrntJN9vWryw8xNMTZWpwUxgaDPxh5c59LkAVKT6tvYt7pM4d6OLFyYx6IL
         yXnOkEoLJ1KznMfvNmsLuxsdqKXDqVJd+wvyKP+f8JCoUBKhxmabZ6BFwqq71afUb/ra
         q0GXh6nCTN1MMfLXU85dV1ESG9+TECyz7H+ev3vJIoWppM0PTtdlPMoayVAMXZw7tRhg
         V0rVj48XRqnHaJQ87NQK6+eO2pIRUVgAhRN13S0qcdhZ1GZEnBtBLADgdKLaf61h1PFw
         YgdA==
X-Forwarded-Encrypted: i=1; AJvYcCXXeM3GOURuXzvdONFe51j6y0zxl8n5ZIEniq1AOZKywuErCWDn2ThgFGcz/ZdnxZws6bNjVMQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOWDLK4LifgwZcpfhZOXUHq+g8tOLabbXao3nnoYd90bSowxIP
	bCur0iloHtDDZxNbecTrkZSkmdA5LzuitdJomxNelOFXjj0xgJJUnhxgADrXQSB3COTEwd3WuqV
	E+gfOZDzIOeBQyn3rD6vJ0qEKcQAtF12Ip3CGi22r
X-Gm-Gg: AZuq6aII3yM0o1ae461DBJrDDLqwv0xC7diRyPtl+Mled0u0lxU0+Xwp1xJqfvuuTAK
	3HQipWoRoqeYLX1zLD8jWajNstPiCGvzpbNxG6bThu6Q+fnRaL+z5BCmDZapoxrRzWz8tjKexjw
	9iaIpvsktSWq20ukuIZ2jWEUCN4tcouYJwlAm0hM1IiH4cKiu/CrfYU6lrILA4I4R+zZ0nlaYs4
	fQ6E2sOYowtnYN/lZiWBZGcowGqcmYbZ7texHlAOo30/aen9I99+1EoIeJYvhGO4Qxl3b3c
X-Received: by 2002:ac8:5d45:0:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-505dfb55052mr19488481cf.13.1770044132084; Mon, 02 Feb 2026
 06:55:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260202130513.49436-1-tabba@google.com> <86tsvz9pbg.wl-maz@kernel.org>
In-Reply-To: <86tsvz9pbg.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Feb 2026 14:54:55 +0000
X-Gm-Features: AZwV_Qj88kuF0nlt2JcSTWbHw1T0UvegRJGqt9wyIYg1kj2dP_rnWko34sG6YH8
Message-ID: <CA+EHjTxC3SXJSHkChVfzLs7C5M4iD59VhKYiHf99MjxuNSPZaA@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: nv: Use kvm_phys_size() for VNCR
 invalidation range
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 2 Feb 2026 at 14:45, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 02 Feb 2026 13:04:24 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > KVM: arm64: nv: Use kvm_phys_size() for VNCR invalidation range
> >
> > Protected mode uses `pkvm_mappings` of the union inside `struct kvm_pgtable`.
> > This aliases `ia_bits`, which is used in non-protected mode.
> >
> > Attempting to use `pgt->ia_bits` in kvm_nested_s2_unmap() and
> > kvm_nested_s2_wp() results in reading mapping pointers or state as a
> > shift amount. This triggers a UBSAN shift-out-of-bounds error:
> >
> >     UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
> >     shift exponent 174565952 is too large for 64-bit type 'unsigned long'
> >     Call trace:
> >      __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
> >      kvm_nested_s2_unmap+0x228/0x248
> >      kvm_arch_flush_shadow_memslot+0x98/0xc0
> >      kvm_set_memslot+0x248/0xce0
> >
> > Fix this by using kvm_phys_size() to determine the IPA size. This helper
> > is independent of the software page table representation and works
> > correctly for both protected and non-protected modes, as it derives the
> > size directly from VTCR_EL2.
>
> I'm a bit confused by the explanation. We have plenty of code that
> uses pgt->ia_bits outside of the NV code. And yet that code is not
> affected by this?
>
> I'm asking because NV is clearly a case where the pkvm_mappings
> aliasing is unambiguously *not* happening.
>
> Isn't the real issue that we are entering the NV handling code for any
> S2 manipulation irrespective of NV support? Would something like below
> help instead?

That would definitely work (just tested it). I just assumed that the
code is there in case in the future we want to support nv + pkvm....
Although, I chuckled a bit as I was writing those words :)

I was going to ask if you'd like me to respin, but this is a
completely different patch. Would you like me to write it up and send
it (my contribution would be the commit msg)?

Cheers,
/fuad


> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index cdeeb8f09e722..d03e9b71bf6cd 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1101,6 +1101,9 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1117,6 +1120,9 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1133,6 +1139,9 @@ void kvm_nested_s2_flush(struct kvm *kvm)
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
> @@ -1145,6 +1154,9 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
>         int i;
>
> +       if (!kvm->arch.nested_mmus_size)
> +               return;
> +
>         for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>
>
> --
> Without deviation from the norm, progress is not possible.
