Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ECF1C32EC
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728560517; cv=none; b=E+icC7vjZMHMldOyOMY4zqw3/6dlIeB2YGDw1UIeXBqrKRcHgcxzr66YR81+rG9CHD2LXI1YrMsV4f2MYQVidpo3cQVSDrjEoR5n51cnJFtGRdiHembIFqfQnraBR+VzO4Ese7ThxyrFlfSSCzmnwqYqxQ9Eae0QmFHFJcZuRqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728560517; c=relaxed/simple;
	bh=cD3n/uf1r9a2FxmfN8WSucBewvCmKvnyhsZqZXLZ0mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBCKP0zpCrYKHwVwPDljzlpU4HhrrFelFsa70qgzQH7nwNTWZMHNYeRF0o/4k+aTtCA1GiDVQryBOrNKjcf6hzbQ3YrzH7sI4ItqkqmC4IZz8MhK5OO7DWe/vzj9orW83XTFwmNrOM1IJgzHsm/iyNmFKJWDeliJhEGt04jcWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=hliHa/30; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="hliHa/30"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a363feabc6so6540195ab.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 04:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1728560515; x=1729165315; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLGEeXitWZKflpz7f8dvCOzHMw8lQ7/MkR5+khK1S4U=;
        b=hliHa/30d+RwvOH1zfle8QVUvOUwvmmoOXLC15fyUh0TA91Nu7cf3qkZ2wuiewonNn
         /tiVj5AqOQsNRUCppbMZ0wy1Xd0Lr77UH/R2OXt6MyY9jojrXoKyeW69NyVSIEnd+Oq+
         urrIQBxn29iyf4zltdwDlxS2OvhR7rufSqqEXRpN36Qw9v2XKe5lRlvQDsi0/TlrezfJ
         sV7C201hty7Yc5dQi7/pzSLzi2A4RyzdDuErOlSY5YjPfHCoMlUmg2R858HEup0JjrKX
         ZAS7xfSogZC0Rm8GYDoBUvbG/nrxor5qBtK4XM3f3/KJ8cUFyupxDkjwbspuqPagvcZ8
         QfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728560515; x=1729165315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JLGEeXitWZKflpz7f8dvCOzHMw8lQ7/MkR5+khK1S4U=;
        b=Mq1Gz3xls0ya/QXrcVAvawLxtPjfpLy43Qsp8AB2Ocuy+cJQdMxMEvn02eFUvkoygU
         vKLsjYo0Ivq39BjaQfojdcA3iIVuVjhLnkfnR8PS2s0U34Iw3AkDPUNHWJDRjQWEVmfY
         bfsZaVgz6jFZ+zEqPJnLZsVximxN5NSloD3lV831QVhdJvZ1ebb1DNAtet0x5LxcJYWt
         Fza5xISsXUKxKPayQJB3B98fVRpAZYQScJhR8zevz3icqTSDK7l/ymE5IPG8XTMae3yP
         EyvAUWr7brQYedZGUYlmS9rQWznJih5VM5l5J4HeUtuRilus09oE/Qum1nUeWnQ+5sA7
         wseA==
X-Forwarded-Encrypted: i=1; AJvYcCWHxUjhMi0RabhpC14L9SrF76I21tWVF14W33T3MvK+rx9tb7PbOGbwNPuR07TJKnxWiC5Ya5o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdK02j1kCe5EsSn4IF1GdsBPiuW9ACYpshp1glyev8a8Ux0I+A
	7NeOVy/M46r9Uhnrpqur2eUxZBnhrbL7DZg0hSeTIJ1TXCspFd+1rl7ckgQHJm6+7a/4fKq0vf6
	F1Js2kXtBZSl2dBxgbscuURwGggKjSwgiXGloWw==
X-Google-Smtp-Source: AGHT+IGdjd1/XT2c4B0Z8vQGIotkt4pyM5B4YYch5zcEe11pNDikzWWp/JAP0Tw+7KI97Zc523H2fMoWAABaV3y6nik=
X-Received: by 2002:a92:c265:0:b0:39f:325f:78e6 with SMTP id
 e9e14a558f8ab-3a3a6d2747dmr16106495ab.0.1728560514733; Thu, 10 Oct 2024
 04:41:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-2-seanjc@google.com>
In-Reply-To: <20241009154953.1073471-2-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 10 Oct 2024 17:11:43 +0530
Message-ID: <CAAhSdy0Z27X9KMF-ps97-s5==7xdA=6B84Mxa2b-um_t+NjWkg@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] KVM: Move KVM_REG_SIZE() definition to common
 uAPI header
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 9:19=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Define KVM_REG_SIZE() in the common kvm.h header, and delete the arm64 an=
d
> RISC-V versions.  As evidenced by the surrounding definitions, all aspect=
s
> of the register size encoding are generic, i.e. RISC-V should have moved
> arm64's definition to common code instead of copy+pasting.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/arm64/include/uapi/asm/kvm.h | 3 ---
>  arch/riscv/include/uapi/asm/kvm.h | 3 ---
>  include/uapi/linux/kvm.h          | 4 ++++
>  3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 964df31da975..80b26134e59e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -43,9 +43,6 @@
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
>  #define KVM_DIRTY_LOG_PAGE_OFFSET 64
>
> -#define KVM_REG_SIZE(id)                                               \
> -       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> -
>  struct kvm_regs {
>         struct user_pt_regs regs;       /* sp =3D sp_el0 */
>
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/=
asm/kvm.h
> index e97db3296456..4f8d0c04a47b 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -207,9 +207,6 @@ struct kvm_riscv_sbi_sta {
>  #define KVM_RISCV_TIMER_STATE_OFF      0
>  #define KVM_RISCV_TIMER_STATE_ON       1
>
> -#define KVM_REG_SIZE(id)               \
> -       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> -
>  /* If you need to interpret the index values, here is the key: */
>  #define KVM_REG_RISCV_TYPE_MASK                0x00000000FF000000
>  #define KVM_REG_RISCV_TYPE_SHIFT       24
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 637efc055145..9deeb13e3e01 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1070,6 +1070,10 @@ struct kvm_dirty_tlb {
>
>  #define KVM_REG_SIZE_SHIFT     52
>  #define KVM_REG_SIZE_MASK      0x00f0000000000000ULL
> +
> +#define KVM_REG_SIZE(id)               \
> +       (1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
> +
>  #define KVM_REG_SIZE_U8                0x0000000000000000ULL
>  #define KVM_REG_SIZE_U16       0x0010000000000000ULL
>  #define KVM_REG_SIZE_U32       0x0020000000000000ULL
> --
> 2.47.0.rc0.187.ge670bccf7e-goog
>
