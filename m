Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456E21CF1
	for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 22:35:50 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6435b851de0so4623835b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 10 May 2023 15:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683758150; x=1686350150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXWsa967kWQ103ztzoiQqsYOxAfVBnqmOcMcaXXMfK0=;
        b=hLPWW/6LDB/o0VythM97kkqBcdiN8QKk6IiYT09S3iCYw+9ptyULgVnnrfSVpDLPG/
         v8+BKDKTTzlFxWyxdH88CSwQ9Q7gGmZJRyBCLBKw0gOzF5+YFIpi/JSuswBIutnBSYzL
         GS2z77PT2rgQL8ZZfCE/wTqNMqV7e/1euiQGssFAPGJhr6Lo839j5RDDbX0MFFi7Uteu
         a6sN5Eks3+vJhPj+kQAAkaN3jmlrWHiXFJorO4Z6pyAT1oSXARtLsiLT2NqXplxoa339
         ZgljXKLDsdeBXqdS4dccC1WgQ6cNVBmZQ3FEGdbpCb6SxVYLx5mgqkP8eyeYrqz86rQD
         V4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683758150; x=1686350150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXWsa967kWQ103ztzoiQqsYOxAfVBnqmOcMcaXXMfK0=;
        b=cYQG4oWghcvVpop9sOsj23qTb1EmNeWa330M1gqdsyW/8CUM/LFygTdcevvuG/N30V
         yeQRH2T7uPoGZnIxkKEbo9GL8WC65wy9sqhep976ePcl2TfclLYzbWCM/SBapDF9AgNB
         Cav19TJ+2+qKqkj+/0TeU4YXboIGkBWRysUsHFkqdqCXwSG036AM1CsgUh91iYUu/KpX
         453ZYKIQRvo1U1BT2EQEPt0vHPmTGFO5w9v7QP6j9FF+n25uiER3ckLNVDDA4AHYUhCf
         dg6PmSmJGyAg6+J9tr2/MK4S/ub0KRCruXL/rYsjGcxduEMui6PK0DY/wgOMWKyj9Xhq
         Yoxw==
X-Gm-Message-State: AC+VfDynCno1k6WmkhC38ZQK4oYg4b3dvuGxsLYMg8yrir6b3W1Lm9L1
	AebKZK0sjIPTHkW7o5DQM/OtuOMI1CQ=
X-Google-Smtp-Source: ACHHUZ5Gy9IA+Ru/c8L2WMQy1v0wXipJ7RD7p6ZiiwmW9YlFbl+2mMgwKT81N6fwSPogBVGQ0I0240fyYmQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bd0:b0:63a:ff2a:bf9f with SMTP id
 x16-20020a056a000bd000b0063aff2abf9fmr5274082pfu.2.1683758149940; Wed, 10 May
 2023 15:35:49 -0700 (PDT)
Date: Wed, 10 May 2023 15:35:48 -0700
In-Reply-To: <ZFrG4KSacT/K9+k5@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <ZFrG4KSacT/K9+k5@google.com>
Message-ID: <ZFwcRCSSlpCBspxy@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, jthoughton@google.com, bgardon@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, May 09, 2023, David Matlack wrote:
> On Wed, Apr 12, 2023 at 09:34:48PM +0000, Anish Moorthy wrote:
> > Upon receiving an annotated EFAULT, userspace may take appropriate
> > action to resolve the failed access. For instance, this might involve a
> > UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
> > migration postcopy.
> 
> As implemented, I think it will be prohibitively expensive if not
> impossible for userspace to determine why KVM is returning EFAULT when
> KVM_CAP_ABSENT_MAPPING_FAULT is enabled, which means userspace can't
> decide the correct action to take (try to resolve or bail).
> 
> Consider the direct_map() case in patch in PATCH 15. The only way to hit
> that condition is a logic bug in KVM or data corruption. There isn't
> really anything userspace can do to handle this situation, and it has no
> way to distinguish that from faults to due absent mappings.
> 
> We could end up hitting cases where userspace loops forever doing
> KVM_RUN, EFAULT, UFFDIO_CONTINUE/MADV_POPULATE_WRITE, KVM_RUN, EFAULT...
> 
> Maybe we should just change direct_map() to use KVM_BUG() and return
> something other than EFAULT. But the general problem still exists and
> even if we have confidence in all the current EFAULT sites, we don't have
> much protection against someone adding an EFAULT in the future that
> userspace can't handle.

Yeah, when I speed read the series, several of the conversions stood out as being
"wrong".  My (potentially unstated) idea was that KVM would only signal
KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user access,
i.e. when the fault _might_ be resolvable by userspace.

If we want to populate KVM_EXIT_MEMORY_FAULT even on kernel bugs, and anything
else that userspace can't possibly resolve, then the easiest thing would be to
add a flag to signal that the fault is fatal, i.e. that userspace shouldn't retry.
Adding a flag may be more robust in the long term as it will force developers to
think about whether or not a fault is fatal, versus relying on documentation to
say "don't signal KVM_EXIT_MEMORY_FAULT for fatal EFAULT conditions".

Side topic, KVM x86 really should have a version of KVM_SYNC_X86_REGS that stores
registers for userspace, but doesn't load registers.  That would allow userspace
to detect many infinite loops with minimal overhead, e.g. (1) set KVM_STORE_X86_REGS
during demand paging, (2) check RIP on every exit to see if the vCPU is making
forward progress, (3) escalate to checking all registers if RIP hasn't changed for
N exits, and finally (4) take action if the guest is well and truly stuck after
N more exits.  KVM could even store RIP on every exit if userspace wanted to avoid
the overhead of storing registers until userspace actually wants all registers.
