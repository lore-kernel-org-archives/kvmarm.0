Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B597C15AD
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:46:37 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id h10so8348211vsu.11
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xCFMMImQJgj/tu+j1F/FPhPRwosktIkw6TcM/cynsiM=;
        b=UwtdppSONPN/WrZpVZPCUfHejZ6uZB/1ejSIFKid321X00DwL0ujITz1T1cPW0S6Ve
         aFQm//LWR5CiqjBy4HKVEuoje3IKGByqaSaZphPol7L8xfqFgCZJ5d403Lx4L+bw4URP
         O6Kemn4NGS3NKbqQs3XcWlGXSE8phbvmbdY6LPsviOEGr57FkR8vb8P3s2dpZTE+WVoQ
         z8UMzlGS0gG+zfE6/VjYoHcrnDw7EAY4grCtfzosBrVd6vizkbrJQk+kUWZechf266EJ
         ZWIUCrh1vzyj4mehAMJzlEO8cNHCNK04Qf6Y4DGMwurGFpSxeSevPJXCN6IUO/Zthexy
         z+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xCFMMImQJgj/tu+j1F/FPhPRwosktIkw6TcM/cynsiM=;
        b=I6cTTER1PcjgfBL+ZVvxDuvPgTUG//4934qefjLkns19bNere2qSX+8WyNysv2LXFw
         nciBXLLRJYdCoBi8hr7p1AKQ5TWNuM0JDGb9b0k9OkY5Wxs05KxYONbscOgbxMpxpCS0
         ugW9JMDkO3ygicCHaiR6rcil1/vwU56m8sRcG+6v4Z1Op493Ao9ZEjneoEt5PxvD79IB
         J9FG8gxJ8fjtKzpwQYeN+Y6V9Foq1vZrz8tYMZ74WsSnb1AUdieQgL2eV4MGr6UfncCf
         uEEQbKdyRFB5ILcMshNPwXV04VeREwrUxjFCp6Ip2PKWaJP1XREiExKaXg1gJps/pkZI
         JFJg==
X-Gm-Message-State: AO0yUKUPDyVJozFhV6EKaf4wEusdiVx20s9FCra5Gyl7riF2qBMyTJpG
	Ke48b+mk0/YjgMIU/I+qVtFx1RBZ+7XwadJmNu8zlQ==
X-Google-Smtp-Source: AK7set9SNKNAHUiEJ9APNsNErXvnGkorkZDqPXw91o8K712nm0Gp/X1U4bSkTCHKdgdsHHk6IjBZIOO1c8RLex4tw1o=
X-Received: by 2002:a67:bc18:0:b0:412:54f:ec68 with SMTP id
 t24-20020a67bc18000000b00412054fec68mr134552vsn.84.1676425596469; Tue, 14 Feb
 2023 17:46:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 14 Feb 2023 17:46:00 -0800
Message-ID: <CADrL8HX09z+NoVEUQQb1KpPEqcj6zfXHEm8f_qJt+LD2nb1yEA@mail.gmail.com>
Subject: Re: [PATCH 0/8] Add memory fault exits to avoid slow GUP
To: Anish Moorthy <amoorthy@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 14, 2023 at 5:16 PM Anish Moorthy <amoorthy@google.com> wrote:
>
> This series improves scalabiity with userfaultfd-based postcopy live
> migration. It implements the no-slow-gup approach which James Houghton
> described in his earlier RFC ([1]). The new cap
> KVM_CAP_MEM_FAULT_NOWAIT, is introduced, which causes KVM to exit to
> userspace if fast get_user_pages (GUP) fails while resolving a page
> fault. The motivation is to allow (most) EPT violations to be resolved
> without going through userfaultfd, which involves serializing faults on
> internal locks: see [1] for more details.

To clarify a little bit here:

One big question: Why do we need a new KVM CAP? Couldn't we just use
UFFD_FEATURE_SIGBUS?

The original RFC thread[1] addresses this question, but to reiterate
here: the difference comes down to non-vCPU guest memory accesses,
like if KVM needs to read memory to emulate an instruction. If we use
UFFD_FEATURE_SIGBUS, KVM's copy_{to,from}_user will just fail, and the
VM will probably just die (depending on what exactly KVM was trying to
do). In these cases, we want KVM to sleep in handle_userfault(). Given
that we couldn't just use UFFD_FEATURE_SIGBUS, a new KVM CAP seemed to
be the most natural solution.

> After receiving the new exit, userspace can check if it has previously
> UFFDIO_COPY/CONTINUEd the faulting address- if not, then it knows that
> fast GUP could not possibly have succeeded, and so the fault has to be
> resolved via UFFDIO_COPY/CONTINUE. In these cases a UFFDIO_WAKE is
> unnecessary, as the vCPU thread hasn't been put to sleep waiting on the
> uffd.
>
> If userspace *has* already COPY/CONTINUEd the address, then it must take
> some other action to make fast GUP succeed: such as swapping in the
> page (for instance, via MADV_POPULATE_WRITE for writable mappings).
>
> This feature should only be enabled during userfaultfd postcopy, as it
> prevents the generation of async page faults.
>
> The actual kernel changes to implement the change on arm64/x86 are
> small: most of this series is actually just adding support for the new
> feature in the demand paging self test. Performance samples (rates
> reported in thousands of pages/s, average of five runs each) generated
> using [2] on an x86 machine with 256 cores, are shown below.
>
> vCPUs, Paging Rate (w/o new cap), Paging Rate (w/ new cap)
> 1       150     340
> 2       191     477
> 4       210     809
> 8       155     1239
> 16      130     1595
> 32      108     2299
> 64      86      3482
> 128     62      4134
> 256     36      4012

Thank you, Anish! :)

> [1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
