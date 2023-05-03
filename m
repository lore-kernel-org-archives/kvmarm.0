Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D725DF71
	for <kvmarm@lists.linux.dev>; Wed,  3 May 2023 21:42:38 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-63b57ad54a1so3343724b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 03 May 2023 14:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683150157; x=1685742157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OvgEgLJsI2QX38aV+BaUu0QfIDBbTkgUarKB1iwkzt4=;
        b=VjGy22vB2jLKiVb/iASIxDKc7A8DXavFgo5TE5pdb2vzr0fuNzfKBg9zNyelgR+ahG
         I8PbmTSMfaa4iMzBUtUSZIj647yO6prF5NVeFwWREhDm5O16MyQOhJHwRGp+BVMq/lxS
         vheAVKSuW6vWSrlMqRdBW0dOnawBeoobH+WW+S35gPcZIpVzCcNuJ3VGcg1edVMe7A/H
         1ZBDdmRou+huZhrRW9UhRyynm5hXhxaOMznNfK6E+pNS6sC0OE/ZaPQ1AJGcwGS3ez4/
         uGGRxqBSvdE97rvMJw9tL299nzInMNBH79JODOq8M/GeBOcd7+VaFR72hiFcW/tpXZPg
         5zxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683150157; x=1685742157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvgEgLJsI2QX38aV+BaUu0QfIDBbTkgUarKB1iwkzt4=;
        b=F4zAUhFoix/5lXml+YHpvZB6BZkTHQVyT/o74N3U1Ixu4Vg/agPXrpN1UJEiJa2hfW
         XauyumT4riF90+4Ww7Y4lxPKQSvIkwy1wilSEFmb01AQuu9y/7Oz+f1PSgQTzARsDpL5
         JM/bsA7rNpSYpbpyaH52nZBvdJ69L4PJL/qgSdMux+k5nW2eRjnG/+zQ+mppEKM7tzBp
         F/R2EabrOzpC0LYdkQdW2uZh7GDHo85FDy1j4lNHTR7gBPFG+uLoqFhV1AY5in+yqSPE
         KQAdGorbuvC/p69VqVK4IgFzpAOuSkmjwlz1xDrzLFYQ1a6CC3Id1XWO/hWVURlK/Vi4
         myBw==
X-Gm-Message-State: AC+VfDy8eU99Mr7i6AwmD5GmthJNj3jgLBIFoYwqeULLtS40QHLwe98h
	dBTQGb2Zpjy4bGTTxCwXIRd4DZqmcZA=
X-Google-Smtp-Source: ACHHUZ5tX8kKCoWD1IcmuHBVZEuCXeYwawwT43LSTxJd0fyXBIeIOCF5zUMdKhjU2jnqD/jWg7GNRYYmM6A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:26ee:b0:63f:1a34:c2fa with SMTP id
 p46-20020a056a0026ee00b0063f1a34c2famr20986pfw.0.1683150157555; Wed, 03 May
 2023 14:42:37 -0700 (PDT)
Date: Wed, 3 May 2023 14:42:35 -0700
In-Reply-To: <ZFLRpEV09lrpJqua@x1n>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
 <ZEGuogfbtxPNUq7t@x1n> <46DD705B-3A3F-438E-A5B1-929C1E43D11F@gmail.com>
 <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com> <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n> <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n> <ZFLRpEV09lrpJqua@x1n>
Message-ID: <ZFLVS+UvpG5w747u@google.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: Anish Moorthy <amoorthy@google.com>, Nadav Amit <nadav.amit@gmail.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org, 
	oliver.upton@linux.dev, James Houghton <jthoughton@google.com>, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, May 03, 2023, Peter Xu wrote:
> Oops, bounced back from the list..
> 
> Forward with no attachment this time - I assume the information is still
> enough in the paragraphs even without the flamegraphs.

The flamegraphs are definitely useful beyond what is captured here.  Not sure
how to get them accepted on the list though.

> > From what I got there, vmx_vcpu_load() gets more highlights than the
> > spinlocks. I think that's the tlb flush broadcast.

No, it's KVM dealing with the vCPU being migrated to a different pCPU.  The
smp_call_function_single() that shows up is from loaded_vmcs_clear() and is
triggered when KVM needs to VMCLEAR the VMCS on the _previous_ pCPU (yay for the
VMCS caches not being coherent).

Task migration can also trigger IBPB (if mitigations are enabled), and also does
an "all contexts" INVEPT, i.e. flushes all TLB entries for KVM's MMU.

Can you trying 1:1 pinning of vCPUs to pCPUs?  That _should_ eliminate the
vmx_vcpu_load_vmcs() hotspot, and for large VMs is likely represenative of a real
world configuration.
