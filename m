Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C538331A56
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067260; cv=none; b=fJRQS193hDEvdp1RrGuJp+J59pon/6q9G6f+Q3f3E/5lUuQN9387/AAJl+ruIM+mA+OjTsn4nWfkR0ZCAcZzbyCUzNQIGDk8UPAMzW9tawj+9WWVXLBHpy2D42ZGRXgq5BM/sGH9BcuBbHGg5Y9NLNqIk+G549bOvGnh0NhHlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067260; c=relaxed/simple;
	bh=lIAig7tUvkXtXkjFtjUQBXAMX5gnC9a5uuDkqG0DwUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YBkal+7B2kgD4YD5kvy2VJHLEzM75sWjWkVB3OopeGpjlP0Ruc1Rr+tik6H3h+BhftZ3XKtAa3m0P+QOoSjgm3kG215iQBN1qaJlfPNhB7prYdEkAQ4PowbS6OUPawGr3siP/+ghGT6UEmB7WBY7e/8bHi+E9zdRqJhXv9lbK/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uDp52UoZ; arc=none smtp.client-ip=91.218.175.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uDp52UoZ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lIAig7tUvkXtXkjFtjUQBXAMX5gnC9a5uuDkqG0DwUI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787067256; v=1; x=1787672056;
 b=uDp52UoZvSUNzEe2G8y0NqIW3yBcGfhbs6OjlXspWxup1O835hE1+ISmm7B7axt4wI4yrSA5
 vV7WU8jtwZ3a09zzUtN5WtEzWNBTLMFuvB1R8rZDjH7hUck12x1atTie0Zl8YYKupvFXwECWwXU
 fpdT34/niiuZvcAVvEGfcrf4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f45.google.com (209.85.167.45)
	by smtp.migadu.com with ESMTPS id c0552fb46ca315f0;
	Tue, 18 Aug 2026 15:34:16 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so8587e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:34:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrPqZ0j9yfAM9stLbUdq2pNdVwFu8XDQKSacIBlX7vNHd8wLhdjpWEPzN7VyaztOCc1Fr312f4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ/aT7a4BQjzgzisVnaayYcbU+Rt/6ZkS1zuJRcaKHA1pWRdGr
	LJm5Cp/TP6EPpv6T/JHccZoKMBypfDA4wRd7Qw+QkGHEOS6P5JhL8j6alFVTSkfzmnXVWr6028z
	hV04U+xQHxRyQhNwFvizePKn6fdfK4R2UDfYQGqeK
X-Received: by 2002:a05:6512:286:b0:5b4:74e2:4171 with SMTP id
 2adb3069b0e04-5b474e243eamr126342e87.4.1787067255336; Tue, 18 Aug 2026
 08:34:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com> <20260731144557.AE9001F000E9@smtp.kernel.org>
In-Reply-To: <20260731144557.AE9001F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 16:33:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx0hjergdVY9QA_oprver04ZDEDzt4aV=Jp_pVCpkssCw@mail.gmail.com>
X-Gm-Features: AcwNN1UYsjeQqgZxajIZ4qeFFphUQpYmE_se_eYbtb9J9ALm7i8zcSrROb_yVHU
Message-ID: <CA+EHjTx0hjergdVY9QA_oprver04ZDEDzt4aV=Jp_pVCpkssCw@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
To: sashiko-reviews@lists.linux.dev
Cc: Vincent Donnefort <vdonnefort@google.com>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2026 at 16:06, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Phantom hypervisor requests leading to infinite loop and memory =
leak on hypercall errors.
> --
>
> --- Patch [6]: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructu=
re ---
> commit ec846697735578e1b5a4e25b88e07602c29ae6a2
> Author: Vincent Donnefort <vdonnefort@google.com>
>
> KVM: arm64: Add pkvm_hyp_req infrastructure
>
> Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
> resources from the host. Provide serialisation helpers to transport these
> requests via SMCCC registers and a macro to automate HVC retries.
>
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm=
/kvm_pkvm.h
> > index 74fedd9c5ff02..6c2497047f8d8 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
>
> [ ... ]
>
> > +/* Return true if a pkvm_hyp_req has been decoded from the SMCCC args =
*/
> > +static inline bool smccc_to_pkvm_hyp_req(struct pkvm_hyp_req *req, str=
uct arm_smccc_res *res)
> > +{
> > +     u8 *src =3D (u8 *)res + offsetof(struct arm_smccc_res, a2);
> > +     u8 type =3D *src;
> > +
> > +     if (type =3D=3D PKVM_HYP_NO_REQ || type >=3D __PKVM_HYP_REQ_TYPE_=
MAX)
> > +             return false;
> > +
> > +     req->type =3D type;
> > +     memcpy(&req->args, src + 1, pkvm_hyp_req_arg_size(type));
> > +
> > +     return true;
> > +}
> > +
> > +int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
> > +
> > +#define pkvm_call_hyp_req(f, ...)                                     =
                       \
> > +({                                                                    =
                       \
> > +     struct arm_smccc_res __res;                                      =
                       \
> > +     int __ret;                                                       =
                       \
> > +     do {                                                             =
                       \
> > +             __ret =3D -1;                                            =
                         \
> > +             arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f), ##__VA_ARGS__, =
&__res);               \
> > +             if (WARN_ON(__res.a0 !=3D SMCCC_RET_SUCCESS))            =
                         \
> > +                     break;                                           =
                       \
> > +             __ret =3D __res.a1;                                      =
                         \
> > +             if (!__ret)                                              =
                       \
> > +                     break;                                           =
                       \
> > +             __ret =3D __pkvm_handle_smccc_req(&__res);               =
                         \
> > +     } while (!__ret);                                                =
                       \
> > +     __ret;                                                           =
                       \
> > +})
>
> [Severity: High]
> Can this sequence lead to an infinite loop and memory leak on hypercall e=
rrors?

This does not happen. Every handler reachable through
pkvm_call_hyp_req() goes via errno_to_smccc(), which always calls
pkvm_hyp_req_to_smccc(), and that writes 0 to x2 when there is no
request to pass back. So the decode never sees a stale argument.

/fuad

>
> When the hypercall fails and returns a non-zero error in __res.a1, the ma=
cro
> passes the result to __pkvm_handle_smccc_req() to check for a piggybacked
> request in __res.a2.
>
> Standard EL2 handlers typically do not clear the x2 register (which maps =
to a2)
> on error; they set x1 to the error code and return. This means a2 retains=
 the
> original second hypercall argument passed by the host.
>
> If the least significant byte of that original host argument happens to m=
atch
> a valid request type, smccc_to_pkvm_hyp_req() would mistakenly decode a p=
hantom
> request. The host would handle this phantom request, return success, and =
the
> macro would then infinitely retry the failing hypercall.
>
> Is there a way to explicitly distinguish a hypercall error from a legitim=
ate
> hypervisor request, perhaps using a specific return code in a1 to indicat=
e when
> a2 actually contains a request?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.95=
6291-1-vdonnefort@google.com?part=3D6
>
