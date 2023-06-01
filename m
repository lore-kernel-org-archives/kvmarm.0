Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E0810FA
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 22:43:31 +0000 (UTC)
Date: Thu, 1 Jun 2023 22:43:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685659409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OwwcO93XUsSL6ykN5XfObGDM2dVn0PA2p876+g1yYcU=;
	b=K2WfBTvSAHfrUiKalALQGQq2zayiZCV9KlBLhF4Krhjs82D/jAE3o9JTggvR2fvpxbqIq3
	NQnh6Hu5F7XLykhAGbO5ynhU5yErAcvseO1npOikikhhj4kqPakjdnTqiphYCT7mVbu57A
	CHD07ERWGhSRfFVZKVuSj34pCzcY0cE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
	maz@kernel.org, jthoughton@google.com, bgardon@google.com,
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZHkfDCItA8HUxOG1@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZFrG4KSacT/K9+k5@google.com>
 <ZFwcRCSSlpCBspxy@google.com>
 <CAF7b7moF1URFC2yZXymPCwvDME8oJafCse12DSf0Rwo43JEDVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7moF1URFC2yZXymPCwvDME8oJafCse12DSf0Rwo43JEDVg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 23, 2023 at 10:49:04AM -0700, Anish Moorthy wrote:
> On Wed, May 10, 2023 at 4:44 PM Anish Moorthy <amoorthy@google.com> wrote:
> >
> > On Wed, May 10, 2023 at 3:35 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Yeah, when I speed read the series, several of the conversions stood out as being
> > > "wrong".  My (potentially unstated) idea was that KVM would only signal
> > > KVM_EXIT_MEMORY_FAULT when the -EFAULT could be traced back to a user access,
> > > i.e. when the fault _might_ be resolvable by userspace.
> >
> > Sean, besides direct_map which other patches did you notice as needing
> > to be dropped/marked as unrecoverable errors?
> 
> I tried going through on my own to try and identify the incorrect
> annotations: here's my read.
> 
> Correct (or can easily be corrected)
> -----------------------------------------------
> - user_mem_abort
>   Incorrect as is: the annotations in patch 19 are incorrect, as they
> cover an error-on-no-slot case and one more I don't fully understand:

That other case is a wart we endearingly refer to as MTE (Memory Tagging
Extension). You theoretically _could_ pop out an annotated exit here, as
userspace likely messed up the mapping (like PROT_MTE missing).

But I'm perfectly happy letting someone complain about it before we go
out of our way to annotate that one. So feel free to drop.

-- 
Thanks,
Oliver
