Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087C23A425B
	for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511467; cv=pass; b=gHSOdYVU8r1MtAOdoBRLyjkCLezhJ/1rmG2kg/zw0jC9JPgYEnshqEqyyKtmM47AOXQ+YQfjuyMCP489Bo8NcNt15kuTk4L9BObYtnz42l7Ajkx1aBeOiNY9qkgtjImS7W+Qofh8dgdx/8bBwY3JFPuq+qJ9T+u/alk+f5nD6MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511467; c=relaxed/simple;
	bh=lz8aaji5zgC3mWJC1SnLk1rnhhRMJ2GV0lKLpP1PYaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fDv39cFIFiAoW3EIGLGOLoQKbLr3l7dmlc4cpzRq3mJkaaNjvZBFJudoGmL6Ys+0NHMPTQHcoFuSbJ3W8WU0akgEtwFtEpt3t7JLi0saFz7ixtRlsuM1bX/hv/rO8O/c/tu4KUqjXamudwBUzmCecGPkN96hnM2uYNKfp3vspKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V0XB5qH6; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V0XB5qH6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-498012a61f6so47735e9.0
        for <kvmarm@lists.linux.dev>; Sun, 23 Aug 2026 11:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787511464; cv=none;
        d=google.com; s=arc-20260327;
        b=PxsJltCvrfvgiAtktjajH9dXEqCAT0sZdPpo1jgWF4iWtgswRiF+4PA3K1iCAx9Hm4
         zOQkjBH2T/gyuZbbrEdOMcLDa2dEFw42CEl8Y/QfviQUEEG9ZbMuCw0Wrw/JrT73F8is
         +lO9Y7Bfc10lNcvQw7LK6JFIocq6PP5OK15yxzd5gVUClGe3/U1bVO4QZ8eETjSSLr/P
         43BbwKlEVQKAP+6t9zQwI5BpfBLTvm5d6QLmSGH+BLgxw3v80FLVq0uU2Wu7Kb1Nouk/
         wBD8mtyQfmeepnezIYxAzid0xl+sLstpxwrj9eh/CSC/MC93S881ARRmwpTMeITOOO5a
         Pgdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z2ncKZyTY/9/D1QKVtbf5dvrVylSRPaXMNaiLdOiT18=;
        fh=+m55P4zvWifZOZ0YjxHb8i38Y6JZ8PPhyW03CPRr9xU=;
        b=Y78R5FOzAwaBzyVHOyXwX23hAdUnAU+E8yjR9IO9lysMc3nWdaiTL0sdfuoCoqqWPI
         mVXK+0FcjozB8lfR9+Iy4cI376A7/vJ+aIpY/v9wuGHBze5m9mGvtBKTz9MJ7CpYpOFU
         ClXjHS4I8nP+vnQGBkXTIAZugeeI6p7RZO16SNa5qK8qxVeTYek3WOq4Lj1m2RcFR3A5
         93MwvNxr9YAWQhO06sNh0WWGQVXC7oz/sOYcv8w94tm1riGfLH7ilPh/h/LCMSzcdACR
         DRlL68ZmUNoFdP+0V8Gj8aKWn42adPd4sTvOa60dDmOwg37nD34IkCAzBswFbGCagrm9
         JPkg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787511464; x=1788116264; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z2ncKZyTY/9/D1QKVtbf5dvrVylSRPaXMNaiLdOiT18=;
        b=V0XB5qH6+6YEdc6Uqq3FxnrnFPcqvKTmwnz4dv4AiAFmL/ZCNqKXVTML5R51wmiHrc
         Q3zILwwYDGga9rNvZ+i2HGO7sVQiBi4Tiqce2maP6VQHGo3DorO34m2nWFvZ9+68NwLP
         HmmgF0nRm6pAg/Y3KXEZSicPiuSqJIMZNYRO3jJq/0XjB+3OfW+QaDG5nuJP4kFVCSJq
         mU6RttgQMqw07fnxUwLfPhNfR1AH1fWwpZE4XbcnphPtt0kxwB8g+WY6bux60vcaZnDp
         vk0XGWF7qy8tTMHSrMdjI8YXaa5kKAre2CuHqEtBgpiosgFjVcjCMFDeM5qzaBJat7Pp
         XBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511464; x=1788116264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z2ncKZyTY/9/D1QKVtbf5dvrVylSRPaXMNaiLdOiT18=;
        b=XzwQKIFJRv4O/PIbabKQrT6vQTdSS1j551R630oH373FR2k5S1MTUPak/ETohF3Az1
         85Uhb3eEZ3EZhDhdxHLBjmf+0FEuTOoOD5pyJRZX5Yoy3QCD5eN5whpl+wIM/hKoJNqK
         Fx7fGuQ0bzn+7uxgnnd18echiYJmPDfVeui7JbsQUsNhmoGmi7mbx8DhphtdV05H3XKr
         5WS7gmZ2bojIY+tLDRMwGQfwsKc2Rykl0dq2nCTgF7YLkGP9/iEqvrIjjkY0780v8i0S
         BS3iupWKZOVWkE9tUNTrNERYZE8DZGEYd3VufSE35fyM0405lxikPTY2ucCys8rwRBic
         iKpw==
X-Forwarded-Encrypted: i=1; AHgh+Rr3ASF1g9uAurwG4MjwNTptvoNCt9xR0P7FEWj1Rae27LKpVqZxq/rI2n88sKSJY+Un++IyEQE=@lists.linux.dev
X-Gm-Message-State: AFuF++mthP/j5Wx6epw4A1c6PZZReWAwMnd+uVg7uydUyTUhfPxelfIH
	p5MxT5izltlv0CWVL5FDLXBoZ4FJkW7GU8MOeu3YL1ZR2XPA5pNiaRTeVTxjYvWIuPQhU+05eys
	qOlINXnJP4tSebFfVcVPle001HoFLxfRjnybWf3La
X-Gm-Gg: AR+sD11e0p2nSzwvyc7lsZvxmiOkQnABZ4kTR2PflxeSMcbNQzh6jDCx75/5ApGYjoz
	qTig+g5oB2SU6Oun0ded3d+Dax84Hd7RUAsNko19URSmQayj+HG/hNgVDv+8AFcdxwxldm1TRKG
	P5fDAg9GwXN+k7IxNMshiWNbyp/oa7y6GUt0OscORb1D6NNAUqqy/r4mfnksl0CF2xlK61YnFFI
	P0iPmMBQ+QsBG4JIDHhOeysL6DYavLVNFUwqUp2Y0BD21lRJNKvdCfKe8mVUlNNWEYWknaZXFVr
	w1ZEkAnG/u9tkn2R2E6Cupx1XUfJlW1wu5g8srM+Gk/qDFW+dk7oTL+zHxPjD8CFuDSCfU/jzkr
	j
X-Received: by 2002:a05:600c:5944:b0:499:a6a5:a687 with SMTP id
 5b1f17b1804b1-499c198e4b7mr1421055e9.0.1787511463662; Sun, 23 Aug 2026
 11:57:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260818112920.26252-1-likexu@tencent.com> <20260818112920.26252-4-likexu@tencent.com>
In-Reply-To: <20260818112920.26252-4-likexu@tencent.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 23 Aug 2026 11:57:31 -0700
X-Gm-Features: AcwNN1UKm1Q7lz-ubUFGA7ulRgZVArWjC692yzAJA6eP0LdE_OW76ZW46Y7eb_4
Message-ID: <CACw3F51+V9fuYeEPH20+KV6589z36OBDsr+Vgmgs4TS+7V=zEQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: arm64: Skip sea_to_user when EINJ
 places no poison
To: Like Xu <like.xu.linux@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 4:29=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> sea_to_user injects a memory UER with EINJ notrigger=3D1 and expects the
> guest to consume it and trap to KVM as an SEA. On some firmware the test
> aborts instead:
>
>   arm64/sea_to_user.c:223: exit_reason =3D=3D (41)
>   Wanted KVM exit reason: 41 (ARM_SEA), got: 6 (MMIO)
>
> notrigger=3D1 asks firmware to arm the poison without consuming it, but o=
n
> these platforms the poison is only armed as part of the trigger step that
> notrigger skips, so nothing consumable is left in memory. The guest reads
> back the sentinel, no SEA occurs, and GUEST_FAIL fires. On arm64 a ucall
> is delivered as an MMIO write, which surfaces as the KVM_EXIT_MMIO above
> rather than a KVM bug.

Thanks for the fixes, looks good to me.

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

>
> The file already documents that the test must be skipped when firmware
> cannot deliver a consumable error. Detect the guest abort that follows a
> missing SEA and skip, instead of failing on a firmware limitation the
> test cannot control.
>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  .../testing/selftests/kvm/arm64/sea_to_user.c | 24 +++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/arm64/sea_to_user.c b/tools/test=
ing/selftests/kvm/arm64/sea_to_user.c
> index 7cf95da8e594d..d4af6e0eed288 100644
> --- a/tools/testing/selftests/kvm/arm64/sea_to_user.c
> +++ b/tools/testing/selftests/kvm/arm64/sea_to_user.c
> @@ -215,13 +215,33 @@ static void run_vm(struct kvm_vm *vm, struct kvm_vc=
pu *vcpu)
>
>         ksft_print_msg("Dump kvm_run info about KVM_EXIT_%s\n",
>                        exit_reason_str(run->exit_reason));
> +
> +       /*
> +        * The guest's read of the injected location is expected to trap =
to KVM
> +        * as an SEA. If it does not, the injected error was never placed=
 as
> +        * consumable poison: some firmware honours EINJ's notrigger requ=
est by
> +        * arming the poison only as part of the (now skipped) trigger st=
ep, so
> +        * nothing is left in memory for the guest to consume. The guest =
then
> +        * reads back the sentinel value and reports it via GUEST_FAIL, w=
hich
> +        * arm64 delivers as a ucall over MMIO (hence a KVM_EXIT_MMIO her=
e).
> +        * Treat that as "this platform cannot host the test" and skip, m=
atching
> +        * the requirement documented at the top of this file, rather tha=
n
> +        * failing on a hardware/firmware limitation the test cannot cont=
rol.
> +        */
> +       if (run->exit_reason !=3D KVM_EXIT_ARM_SEA &&
> +           get_ucall(vcpu, &uc) =3D=3D UCALL_ABORT) {
> +               ksft_print_msg("Guest consumed no SEA: %s", uc.buffer);
> +               ksft_exit_skip("EINJ notrigger placed no consumable poiso=
n on this platform\n");
> +       }
> +
> +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
> +
> +       /* arm_sea holds valid data only for a KVM_EXIT_ARM_SEA exit. */
>         ksft_print_msg("kvm_run.arm_sea: esr=3D%#llx, flags=3D%#llx\n",
>                        run->arm_sea.esr, run->arm_sea.flags);
>         ksft_print_msg("kvm_run.arm_sea: gva=3D%#llx, gpa=3D%#llx\n",
>                        run->arm_sea.gva, run->arm_sea.gpa);
>
> -       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_ARM_SEA);
> -
>         esr =3D run->arm_sea.esr;
>         TEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_LOW);
>         TEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
> --
> 2.50.1 (Apple Git-155)
>
