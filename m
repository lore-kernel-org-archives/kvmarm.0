Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064B69444
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 20:41:47 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-64115e69e1eso82515b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 13:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683060107; x=1685652107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1xT6Cy3XHsLOOGIfij/aWoeXWzYY5kDVhaeCmtEpLI=;
        b=CU9m786t178y6G9yo7NRnuVonUA1T6tCM09qzkEymu2841t5iWyn9Ud3NuErkylfMB
         zOL0ts72Klrj4WlWCV7DHlnjUwbBCelkrgDk6DHOcWMjdsfgt9cRWidRn9nG0719CB9I
         x+8TCWtv8l2UUPWrfwmMApfMpsDwc7Wt5ahbpYaZvZSqKqTTN2yMDPLKmOwkzVFVEw8m
         gbiGNR7hY5xH7ZTCuM7j8+kivyRoZvwyRjVClo3ICe6Mt9WCbl19ASmcXw0QMy38B2/6
         r4Pg/iviE73KarQYUzXev7KozZcfVRrtj2wxISVDVXh8GHka8nwkUSxp+PXDaGy6bVFH
         idtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683060107; x=1685652107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1xT6Cy3XHsLOOGIfij/aWoeXWzYY5kDVhaeCmtEpLI=;
        b=WMBbgACMMueQxhxIISPISLUtlHC/CwpHdpyoU9OAQZ/OipmBqR3LmrXz08qs09R2L7
         Wd3w3fTabtjpnCyaA3GelZTCwTKBw+JneQe5ahv0L/7m/rwCoQmQl8AW+tSp2kNd2q75
         g4TMnOWKHEZwIFcNW+dEf+PNT6wQGiOppejwkEbBf723hRGHNcE593tCabXGEu7etHnn
         wcicE7GoWP0rfsfYf9pnU4Gf0A2859a00ozR8guiVWXWCsKJgH6GFAn0NYXTDIjomUL0
         6suRWkF90WJtTTLfo+Pj6hOPUVOhun2D0eVXntPdPLupUfB35di/yoQna+wZ4H731NkD
         PAqg==
X-Gm-Message-State: AC+VfDxygogz9h5/80I0KovgyWGQg58uW3sk2K7P3nOPgAsD2c7EplS2
	McvJbVb1Sje2zpGgN+8p8xPacnJOAqc=
X-Google-Smtp-Source: ACHHUZ7Z2F3qdn8usjq2NWZcWjfwltlLS38Glt0+jjWUNErXARTzv1Y9FNS6hwgz0tmajg5no5fMFCf7UMg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4c15:0:b0:524:fba4:fd51 with SMTP id
 z21-20020a634c15000000b00524fba4fd51mr5673227pga.3.1683060107406; Tue, 02 May
 2023 13:41:47 -0700 (PDT)
Date: Tue, 2 May 2023 13:41:45 -0700
In-Reply-To: <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Message-ID: <ZFF1ibyPZHKYzEuY@google.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, May 02, 2023, Anish Moorthy wrote:
> Thanks for nailing this down for me! One more question: should we be
> concerned about any guest memory accesses occurring in the preamble to
> that vcpu_run() call in kvm_arch_vcpu_ioctl_run()?
> 
> I only see two spots from which an EFAULT could make it to userspace,
> those being the sync_regs() and cui() calls. The former looks clean

Ya, sync_regs() is a non-issue, that doesn't touch guest memory unless userspace
is doing something truly bizarre.

> but I'm not sure about the latter. As written it's not an issue per se
> if the cui() call tries a vCPU memory access- the
> kvm_populate_efault_info() helper will just not populate the run
> struct and WARN_ON_ONCE(). But it would be good to know about.

If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking at the
code, the cui() aspect is a moot point.  As I stated in the previous discussion,
the WARN_ON_ONCE() in question needs to be off-by-default.

 : Hmm, one idea would be to have the initial -EFAULT detection fill kvm_run.memory_fault,
 : but set kvm_run.exit_reason to some magic number, e.g. zero it out.  Then KVM could
 : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN would need to
 : be buried by a Kconfig or something since kvm_run can be modified by userspace,
 : but other than that I think it would work.
