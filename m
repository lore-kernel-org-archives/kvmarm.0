Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A091179
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 00:07:04 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4881ac152b5so3853e0c.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 17:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692058024; x=1692662824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEb/LALV6ac5FnGK5WrJgICv/9PyQoMajfPza96VUQo=;
        b=DwuVEz4JSsZHVlYPo5/0uGw0vF6PVEoFMndDCjy7Xze8LDueMPDF9Pp7ZkZnY/d0CT
         JCtfkLzUhpnNNou4G69uaoUoIb19o5DY40LlyrM8fuPvMOt2qhnyo8hlc3N+E6tUJ835
         M+KQxYv3ww1vSZ1tzHs9to2SbY4kkNJN54lDZtJxmnZcBCOWw9g/JhJOvh943aLBWEyF
         ZaobUvc2lF/zTSryWfeglBni8Sz0fsOis7UtmZlKZdgFIGuy6cBhJmP9v/BuVPS+I4Zk
         1OB5Y2dW/33DPFw709/6rLrZihjpghiic6AXuWItBj/bRxVNey63LhJHcOayLG5nUyzo
         IHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692058024; x=1692662824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NEb/LALV6ac5FnGK5WrJgICv/9PyQoMajfPza96VUQo=;
        b=ivSpTCp/huRlHcML6N9z3EyyyjngCO/mZ1NTBe/MZbfNmIbdFOul1PmmlGyR7AT0u8
         +ZVhGqkEMOX8zrw6/+omthR0ZGZbTyEqj2vTpXZvpq70EXshdtlwBlr6/Re+kY8Luj+0
         kpxLvijOnUBbiQXPhnY9nGbA/jMoCHYs57jU0jIFpeJg9J2XQebZM26spMLW8dN6w8ud
         MNmfHMcRzIqKZLlLx/DbduFw5w2dDvDfNMTYAk55XZ3sEe0q5fFX6IciYOKXKc5jkBx7
         i06R8g0Gmef3kjotFwNYODByemQSneYSVKfi7JKK9zDKyuhfe6GwpWEjYfBmGm++umNs
         cLQA==
X-Gm-Message-State: AOJu0YxDMfcKG79u23ahDaX6tZwdStJecJ3TTwnTXJ7H6asOqqaKugu3
	q8Nehz8RdWjPaaMp0LeSqkz4jEMFqstfqAnypa5Ghw==
X-Google-Smtp-Source: AGHT+IHsIHwWXyqKbw7AFdpj6pk0PdEeqqURN+HPrG/ZUKB6E/6g9lCm3ByHYeozRrG1lCRfMQ1nz8sfwhXku6E9G68=
X-Received: by 2002:a1f:ea44:0:b0:487:e8f1:a2c1 with SMTP id
 i65-20020a1fea44000000b00487e8f1a2c1mr7836670vkh.8.1692058023805; Mon, 14 Aug
 2023 17:07:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com>
In-Reply-To: <ZNpsCngiSjISMG5j@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 14 Aug 2023 17:06:27 -0700
Message-ID: <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 11:01=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> What is/was the error?  It's probably worth digging into; "static inline"=
 should
> work just fine, so there might be something funky elsewhere that you're p=
apering
> over.

What I get is

> ./include/linux/kvm_host.h:2298:20: error: function 'kvm_handle_guest_uac=
cess_fault' has internal linkage but is not defined [-Werror,-Wundefined-in=
ternal]
> static inline void kvm_handle_guest_uaccess_fault(struct kvm_vcpu *vcpu,
>                    ^
> arch/x86/kvm/mmu/mmu.c:3323:2: note: used here
>         kvm_handle_guest_uaccess_fault(vcpu, gfn_to_gpa(fault->gfn), PAGE=
_SIZE,
>         ^
> 1 error generated.

(mmu.c:3323 is in kvm_handle_error_pfn()). I tried shoving the
definition of the function from kvm_main.c to kvm_host.h so that I
could make it "static inline": but then the same "internal linkage"
error pops up in the kvm_vcpu_read/write_guest_page() functions.

Btw, do you actually know the size of the union in the run struct? I
started checking it but stopped when I realized that it includes
arch-dependent structs.
