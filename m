Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB1E1D5AD8
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736805858; cv=none; b=VFrg5412/KcwbcRNbbQuuFPB4j0fKF6aRri61GQSx+bw0ahr0NiBL2FDyP3TgWQtrDS71mfINjl91EPWsvvezRjTtPTQhpCJzjtOhYYf/J1ALZXZnFikGPt4JgYCIeZLmOPxcw0AY3k2cv4Op0EiYQbwyRwN9O+9o1+vmBiVDlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736805858; c=relaxed/simple;
	bh=EchIjsJPujj7t/pv7t0veqTlDk1UffPAlzXdJgJLSDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSBEscMjcRVD48urbdahTSKZDEcM66GLKpP1KehQU+B9EL2UVcA2sGb+jj8co0tOcSOnY+fgKA43QMdSLNzDcqB5q2WKeTnGQsKSu+flkUtub8KpsbnrJH5x7WYj8okZ2UQ08/Yy3p/LlaDKplwb8iKXhCQ5ARJyapuPePpDUnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Ywuzhx9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Ywuzhx9"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso8656381a91.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 14:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736805856; x=1737410656; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ouQM0W6rpy+hi197i8Zk+lTDosT4d/QAcoc26c/0W4=;
        b=0Ywuzhx90CA411BErMkKlYxj1O1Tph0KKDPP7j/7Ftv68qyekDpP06cPQ31WI/AKf4
         Z0bfuTOmbdcf3+xcY7h05AN9X5tS4WT2cLHo2VJn8e0dhaQDM7HH7XgkpmlbMTQftviD
         8N7rlVyBNIhsW8lUzSzk1gAeGX8HDJynQIdKylpF99FHiABqWPB7SMuDuUgHgmxxO5yF
         cix3HvXqWmltjikF+/CK+PW+EIcF8h+G3Ylnbq+68GFueDwN2k/kycIWDgGkxunyjdyz
         xV55rEqPMP719lT8vCOSC/i82vY971wMpmLN5hXni3lnqHAw56o+AGao5V7QNxOMd76I
         oIYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736805856; x=1737410656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ouQM0W6rpy+hi197i8Zk+lTDosT4d/QAcoc26c/0W4=;
        b=MKdxRKyMDDv504oKOXalz6fg+c3SyvnDf6aH8au3l/seT2AnE1E+vb5ZWmT815xs9N
         /DZm5Q4yz7wnTzjIgh2a612w/xUgc+bW34N/XJcx5jm/MtyC4+K+0hTbchX6c0el/os0
         GTdPHhu31BIDgsV5T8C/rTPSOOpuac7RcRlWAdZMLeIII99Z5juvasMGrE2dBPDLtEpM
         S+bN55v407KMVjm+48ePg7hs2F/E+SxnUYt7SvJhRA4K7MdV8q18XyzkFqLp309kLee/
         jDMybxXcZd+wwUYvNVpnychBSBnr+kShbf0Kgccdiw5HL3LiQ9kRItqlb9tqUNHpIknO
         ioUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBZYdKHq16FIuZ1zMyvPTr+zeJpEhGhFV3CdiNFrcaLhC7rjVef7rSzg9zY0IW0VTQSqTMbl4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+f2Zw4BlJfQ0f0D4D8tC4eUnrbUBF0p0HYX831xbiqfV44gQm
	/LF1W0FbQ5F+dbe8tR4ysRKK7MFQsl2iLfaUIIqb56qTPF9n/1VtIJh0jCzabxs0TAsFZCbGyHu
	eRw==
X-Google-Smtp-Source: AGHT+IHPN8TIZGkXrQIWMGITx0F8fOm3vw8dMWb7JVx/B9HZzRXtZecChEPlXNK7/wkOh+HdmqOb1zcL5aE=
X-Received: from pjbdb14.prod.google.com ([2002:a17:90a:d64e:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f90:b0:2f6:f107:faf8
 with SMTP id 98e67ed59e1d1-2f6f107fe30mr4478474a91.24.1736805856584; Mon, 13
 Jan 2025 14:04:16 -0800 (PST)
Date: Mon, 13 Jan 2025 14:04:15 -0800
In-Reply-To: <87bjwaqzbz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <87ikqlr4vo.wl-maz@kernel.org> <Z4U03KRYy2DVEgJR@google.com>
 <86ikqiwq7y.wl-maz@kernel.org> <Z4ViZb7rruRiN-Oe@google.com> <87bjwaqzbz.wl-maz@kernel.org>
Message-ID: <Z4WN3_wUZ1H_e7ou@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 13, 2025, Marc Zyngier wrote:
> On Mon, 13 Jan 2025 18:58:45 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Mon, Jan 13, 2025, Marc Zyngier wrote:
> > > On Mon, 13 Jan 2025 15:44:28 +0000,
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > On Sat, Jan 11, 2025, Marc Zyngier wrote:
> > > > > Yet, you don't amend arm64 to publish that flag. Not that I think this
> > > > > causes any issue (even if you save the state at that point without
> > > > > reentering the guest, it will be still be consistent), but that
> > > > > directly contradicts the documentation (isn't that ironic? ;-).
> > > > 
> > > > It does cause issues, I missed this code in kvm_arch_vcpu_ioctl_run():
> > > > 
> > > > 	if (run->exit_reason == KVM_EXIT_MMIO) {
> > > > 		ret = kvm_handle_mmio_return(vcpu);
> > > > 		if (ret <= 0)
> > > > 			return ret;
> > > > 	}
> > > 
> > > That's satisfying a load from the guest forwarded to userspace.
> > 
> > And MMIO stores, no?  I.e. PC needs to be incremented on stores as well.
> 
> Yes, *after* the store as completed. If you replay the instruction,
> the same store comes out.
> 
> > > If the VMM did a save of the guest at this stage, restored and resumed it,
> > > *nothing* bad would happen, as PC still points to the instruction that got
> > > forwarded. You'll see the same load again.
> > 
> > But replaying an MMIO store could cause all kinds of problems, and even MMIO
> > loads could theoretically be problematic, e.g. if there are side effects in the
> > device that trigger on access to a device register.
> 
> But that's the VMM's problem. If it has modified its own state and
> doesn't return to the guest to complete the instruction, that's just
> as bad as a load, which *do* have side effects as well.

Agreed, just wanted to make sure I wasn't completely misunderstanding something
about arm64.

> Overall, the guest state exposed by KVM is always correct, and
> replaying the instruction is not going to change that. It is if the
> VMM is broken that things turn ugly *for the VMM itself*, 
> and I claim that no amount of flag being added is going to help that.

On x86 at least, adding KVM_RUN_NEEDS_COMPLETION reduces the chances for human
error.  x86 has had bugs in both KVM (patch 1) and userspace (Google's VMM when
handling MSR exits) that would have been avoided if KVM_RUN_NEEDS_COMPLETION existed.
Unless the VMM is doing something decidely odd, userspace needs to write code once
(maybe even just once for all architectures).  For KVM, the flag is set based on
whether or not the vCPU has a valid completion callback, i.e. will be correct so
long as the underlying KVM code is correct.

Contrast that with the current approach, where the KVM developer needs to get
the KVM code correct and remember to update KVM's documentation.  Documentation
is especially problematic, because in practice it can't be tested, i.e. is much
more likely to be missed by the developer and the maintainer.  The VMM either
needs to blindly redo KVM_RUN (as selftests do, and apparently as QEMU does), or
the developer adding VMM support needs to be diligent in reading KVM's documentation.
And like KVM documentation, testing that the VMM is implemented to KVM's "spec"
is effectively impossible in practice, because 99.9999% of the time userspace
exits and save/restore will work just fine.

I do agree that the VMM is likely going to run into problems sooner or later if
the developers/maintainers don't fundamentally understand the need to redo KVM_RUN,
but I also think there's significant value in reducing the chances for simple
human error to result in broken VMs.
