Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA23B8F6E
	for <kvmarm@lists.linux.dev>; Tue,  2 May 2023 19:50:24 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f315735514so183430105e9.1
        for <kvmarm@lists.linux.dev>; Tue, 02 May 2023 12:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683057023; x=1685649023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aqI5T8eLMgeyqD26lhRa9P7yJtAZhZLu+/rRmSJfqpA=;
        b=mr/EA+sLRTXYRCpA7Ws/FAyfpXxhdIVTdxWL/lPo9ofzrRWsBdQlfnSG+d/rhLkxPI
         SykHb8O+2CiT7232YNKdqTsmCG0pi1ru2TVjPFtLakBzMyUQ7AM5vtiAAZLlF9OR0HhL
         NhhjW+xXBzwZ0N24/qMwJjMN5R88wWbHN0FVuj+wEl1FYN46m6M0ABsP0GYPmX/MmzGi
         Z+PpNHL0fQ2Bv8AWeCkKseu2blsDXs4CF654PyS8QT38NltPWCr/IO5+d69ruKb0KYTx
         FV2ex2NHrh11OqzPpOFq87KPP1VVPYn8bNewLsYwqX2LdqWkS72XBhfedqiSBCV7JdPn
         aIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683057023; x=1685649023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqI5T8eLMgeyqD26lhRa9P7yJtAZhZLu+/rRmSJfqpA=;
        b=JFYQvan1Y7vYxVQlE2ccqhT5liqb18G+o+2DKC24UpetEA3z7k9/b8Y4oRJtTH6LR+
         fm5Sxk7WxH9PEWsJcB+xGLQ8/4QNsqdbOXuSToVn5JZVExqQwyIOmJaj3HJLci5NdWHQ
         lGyaSCxjPxlP7Jg6gKnhdOOUUenFJd5Hws16X3D+W6h0MPpCwF/rclmO1x2f2JmDxyXM
         1YHa7aLCKzX1lUz1IABXfNje84dzz56rMymo5DNVlJfcQl0nH8+ryxEPqQjviAhIO4/u
         nqfdbgQZ94vzrnQNcbOamwyH25k+uqNrax/KPDvjO8o7l20bFY8vbhL9nHByo7Gw0ahH
         j8tA==
X-Gm-Message-State: AC+VfDx7r9AMZsmaUchWQzXE0P87NZif9nxrrIOfPr17DdAH7w2hr7ei
	BsVdwpHEi+I5UMaKD0Kvu7lzTs64cyeldF3L7dIFmQ==
X-Google-Smtp-Source: ACHHUZ49Qn3lCeoXNSoHPj9ir2pp1XXjSo3jgUFRk8BgO6qVl3wb4f7N2j2N+WRoNVcWSS8gdc3K0BrNVCIGYEG6deY=
X-Received: by 2002:a05:600c:1f14:b0:3f1:80d0:906b with SMTP id
 bd20-20020a05600c1f1400b003f180d0906bmr15121813wmb.4.1683057022778; Tue, 02
 May 2023 12:50:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com> <ZFFbwOXZ5uI/gdaf@google.com>
In-Reply-To: <ZFFbwOXZ5uI/gdaf@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Tue, 2 May 2023 12:49:46 -0700
Message-ID: <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Thanks for nailing this down for me! One more question: should we be
concerned about any guest memory accesses occurring in the preamble to
that vcpu_run() call in kvm_arch_vcpu_ioctl_run()?

I only see two spots from which an EFAULT could make it to userspace,
those being the sync_regs() and cui() calls. The former looks clean
but I'm not sure about the latter. As written it's not an issue per se
if the cui() call tries a vCPU memory access- the
kvm_populate_efault_info() helper will just not populate the run
struct and WARN_ON_ONCE(). But it would be good to know about.
