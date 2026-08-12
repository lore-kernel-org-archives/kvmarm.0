Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C64369D6F
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 03:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505140; cv=pass; b=AWqUWbbl/3CgAK0+sQWErILHSSvT0qJdRjC80RVKFfiW1cmKhN1LIhmKgiJB3CaX7reMuP4LE1yFBXVgnJSjMd+8jvR0H8RuUh12Z9gTxjrMCQRxcKduRvy7afwyHBzCq9BsvDyVUJ0yAHzeJ7kjXcBqmvu0va8FFI9wmCbNqn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505140; c=relaxed/simple;
	bh=8eBdffJzIDgLmDfD73g8in+j36Jkh74FeOyl9b2izWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ze1GSCTutbep/un/jsdtisaYzcSlLNTkHNz+pwozQSKBC6DfGT03uCTtare0ZEUopdpffPhKwEnwEKG+ZPMbY8ZJKweEvsf+6z3fvNtwbp/xoBOjpoUVqqYNNvDqOXvCKrcaUAqDppcaxRWOWAdDAq2+4ownjwhUldK0SD128lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nix0pxWe; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nix0pxWe"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f23e851626so3311166d6.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 20:25:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786505137; cv=none;
        d=google.com; s=arc-20260327;
        b=BkueTVV3ziBY2a6NpDMhtdzCMGGc8eq8NkiNjBvd3HHB3awR8mEK1SVslx1kg8SQKo
         zhra/1LNM54/130U231aGcmsWTjq4+ldK/9ATTYKN89rlxl3iTyFH7bTrwa55Uae4zKF
         WfrvoG00DwEdpqSTNbjnKXy7iMMOFvZ24i8HS/QWOMSGyxzLHCwDI/pf/YcOiVsy5pDT
         cfJXWUp91z3Tc7hJqEvbcqFPypbS++r9ZiIYLq9W5jQR7d6rozX0R6SWpV0JCoGQkVFg
         tVodGWyQAxK9+pIAMLEARygKn0CeExlAiSCEt2NuTjRBa7sQOD9IEF/a6KbWGCOldzNy
         4Tpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sbAE3LPUDSURazUhNIkFniQu501TuI9sZ6Nx1+2SCHw=;
        fh=6Qr6X3Ig3s/9+n8sDvoTDeCDKcNos/oS07tEulOmgTg=;
        b=T34ivg/4muBAnWWzV1BpUWBTpbAuOHyqSNKdcErYM84mQG/T8uMVxEuB6Y05fdzQ1w
         46ay/uYZ8kxz9etvobADzdXeysWxFJyxvfkSrvdB9jps1gv/YI7I+geKNScLCvmri/Vu
         C8/XmTmZ0eBOdSHmkri6Ll/7yJMUoOL1ZTSF661sqp/DPgDTeIuYmSKozJkxj5Wst8DW
         0GqZlNfqKV/MDkeVRV1mUXuqXPTHblEa50DKKAH8YtdYaOnkcIAvOlzVoUhYgEVMkGBj
         tsQEPiCxuopQo0eaI2rFr2OkZMGwrafM5GJX2OrH1BN1otN5okMvHNkc33nSraaB7RTe
         R2/A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786505137; x=1787109937; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sbAE3LPUDSURazUhNIkFniQu501TuI9sZ6Nx1+2SCHw=;
        b=nix0pxWeC6M2rU9MdS6lZ7ywmpcaa2N+jz0ztgyK9oY7puMX4mKthzz11dj6bsbJY8
         6IZ/M8PPY3hQIfN/mDSdmjZ7DuS8+7jqfEQgLYeWqIfH4pcRkqLV5W5DJQKTIUY52lau
         ZpKufdNzmXWjaTaMLdCHWxrZhPzw5oRYF2GWw4Bq15r5dxY03MuE815aP5pPfxURHtJT
         VmGX9ILcwms9RNYIAyBz2YweDPWKdscUjfcKFcYY8dguQayxzWA0OuP88JSnJKnMPxxJ
         KSPPRoE5P/War77BLQtOuXyXdCcsps1wRx1bJlX3y9Km6+wpGqFJxLN21rBOOqqRaueK
         5pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786505137; x=1787109937;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sbAE3LPUDSURazUhNIkFniQu501TuI9sZ6Nx1+2SCHw=;
        b=BTcQ1Q4DM//Dg8KeCZ2PgMUZj7csvRLCIM7Kw01CMiRohTBIwkwE1lrXc0aobzQGBv
         UodkgWcUF97g6cVpLmtnyIzYqnAnUlMOgHjHDZLpr32QkDvcoc1jwvK/oen90mscDfnt
         /VJOcjQYCZkY5vGylUNlpmCEOXffMW0FPuBrqXgxP42hacc68hGIJ8MyWDDTnFQ2wldT
         w5QQqG4Rlfx4h+2sInU+npmLjx0GvlbUSD9vOL1xZeXkS4fVcfp5F/MMKaqZPUy1K9LZ
         UIFwRJhXhhrqgTUX2FU8+u+auv4hO7OeBBPWxhPBurz3D7kILnRrxRIwq+MzMsG5QvAk
         Dwig==
X-Forwarded-Encrypted: i=1; AHgh+Rqt0XQXLANobOS4XdUD/N0Yfj4AEPWcU3LZDEEjqZKDpQB3NIsZVZL9C0KoTM6Kuyr/0iI4mb8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmSMN316T73HZmAwN44zXuN+8VJaLN9mmBTTS+cP87G4TIKUdL
	9SqRpoO+zldom6dCH4nX2Ub8x8KJiN4RZlKLtNFmTYYBU3g4yPJY2LvxT0tz08UDYuMErBdpxr5
	9R7cK2MfE+uZlbCvS+gOXsdiruaanwC0GfkALbYgT
X-Gm-Gg: AR+sD11pR8cEfvjFsOPmtESI0w3/9x58oeaaUXICGD6ybR5LbQwNogQ2Reb/xq7JwES
	/mztGDsStpTk+LMlnMbRtX1xFhtlFP+myLl7XyRJZH6e862dzQO+fUQ38vxt2fQZHK5IkKIKAGs
	U+IMIiL/ocMcAlYvjs8w4xWpqxwb/PAQhv1Mmx/yZjZs2RA4yBUTl16rvA8nh3CuwVW/8+EBGez
	/Ud5FSsZ7rN+0WjLbwMMEz+UkcuPNUa47jSeKlXvE8seyT8vXtGs7hNO91rgNRJkbV9z0wY3wo4
	CJfREfnzjVw+c4LLfOn6KY8Cm7fg2hlVFCU1nl3IsIifXmdDJq1zkFyD
X-Received: by 2002:a05:6214:230a:b0:907:c056:d63a with SMTP id
 6a1803df08f44-90a6ffd0170mr15698606d6.20.1786505136817; Tue, 11 Aug 2026
 20:25:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803134403.80630-1-steven.price@arm.com> <42170467-fe36-4382-867f-49bdc6a7bc9a@arm.com>
 <d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com> <5e86232a-89ed-40ff-89e2-9e48fbf9554e@arm.com>
 <e2894206-7470-4606-b9ac-eedc8d2bdaf3@redhat.com>
In-Reply-To: <e2894206-7470-4606-b9ac-eedc8d2bdaf3@redhat.com>
From: Alper Gun <alpergun@google.com>
Date: Tue, 11 Aug 2026 20:25:25 -0700
X-Gm-Features: AUfX_mydHvtdt9zTnMQDxMEfQcPxjhamET6J18JMLKXgxKIfjEME9sN1_LoiXoQ
Message-ID: <CABpDEukGY+ctSi6wHAaC7o4pGmastX_Y18K2_VYDhNME7TF+wQ@mail.gmail.com>
Subject: Re: [PATCH v16 00/45] arm64: Support for Arm CCA in KVM
To: Gavin Shan <gshan@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 8:08=E2=80=AFPM Gavin Shan <gshan@redhat.com> wrote=
:
> As the following calltrace indicates, -EAGAIN is returned from tf-rmm::up=
date_ripas()
> because true is returned from s2tte_drain_pending() for the S2TTE corresp=
onding to
> IPA 0x80000000. Linux host received error (RMI_ERROR_RTT, level=3D3) in r=
ipas_change().
> Upon this specific error and the IPA range [0x80000000 0x90000000], find_=
map_level()
> returns level of 2, and realm_create_rtt_levels() returns 0 without popul=
ating any
> RTTs. After that, rmi_rtt_set_ripas() is re-executed and the above loop s=
tarts over
> again.
>
>    Linux host
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    kvm_arch_vcpu_ioctl_run                     // cca/host-v16
>      check_vcpu_requests
>        kvm_check_request
>          kvm_rec_handle_request
>            kvm_complete_ripas_change
>              realm_set_ipa_state
>                ripas_change
>                  rmi_rtt_set_ripas
>                    SMC_RMI_RTT_SET_RIPAS
>
>    TF-RMM
>    =3D=3D=3D=3D=3D=3D
>    SMC_RMI_RTT_SET_RIPAS                      // tf-rmm/topics/rmm-v2.0-p=
oc_3
>      smc_rtt_set_ripas
>        s2tt_walk_lock_unlock
>        rtt_set_ripas_range
>          update_ripas
>            s2tte_drain_pending                // true, returns -EAGAIN
>
> The problem is the pending-bit for RTE corresponding IPA address 0x800000=
00 isn't cleared
> when SMC_RMI_RTT_SET_RIPAS is invoked. I didn't figure out how this bit i=
s set and why
> it's not cleared in time.
>

Hi Gavin, Suzuki,

I think I ran into a similar issue on rmm-v2.0-poc_3 last week.
This looks like a potential RMM bug: could bit 32 be part of the physical
Address (if PA >=3D 4 GiB)?

It seems s2tte_drain_pending() in lib/s2tt/src/s2tt.c checks bit 32 without
checking whether the descriptor is valid or invalid.

In my testing, guarding the drain checks with a check for S2TTE_INVALID see=
med
to resolve the boot hang:
--- a/lib/s2tt/src/s2tt.c
+++ b/lib/s2tt/src/s2tt.c
@@ -1701,6 +1701,10 @@ unsigned long
s2tte_clear_drain_pending(unsigned long s2tte)

 bool s2tte_drain_pending(unsigned long s2tte)
 {
+ if ((s2tte & S2TT_DESC_VALID_MASK) !=3D S2TTE_INVALID) {
+ return false;
+ }
+
  return (s2tte & S2TTE_SW_DRAIN_PENDING_BIT) !=3D 0UL;
 }

@@ -1730,11 +1734,19 @@ unsigned long
s2tte_clear_tlbi_pending(unsigned long s2tte)

 bool s2tte_tlbi_pending(unsigned long s2tte)
 {
+ if ((s2tte & S2TT_DESC_VALID_MASK) !=3D S2TTE_INVALID) {
+ return false;
+ }
+
  return (s2tte & S2TTE_SW_TLBI_PENDING_BIT) !=3D 0UL;
 }

 unsigned int s2tte_drain_handle(unsigned long s2tte)
 {
+ if ((s2tte & S2TT_DESC_VALID_MASK) !=3D S2TTE_INVALID) {
+ return 0U;
+ }
+
  return (unsigned int)EXTRACT(S2TTE_SW_HANDLE, s2tte);
 }

Sharing in case it helps.
Thanks,
Alper
