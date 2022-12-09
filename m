Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246377E8
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 01:08:58 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id fy4so2952013pjb.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 17:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0W5fcABi4X+T/jYwfg3acG+mAXpKXLqoOLMcVDvb94=;
        b=YriPTaeIiA+dLmTSSSXERGxZoMyfxJhoF2Q8RM1j7icfTqEwdCfNmwHRywZVksID9N
         yt3L9g633vwLWxIZEY1PievSOwRoolVjFuC2ekFqhXWDrbAgmSyOG8E61xcBei/0WmkD
         n3zTXHfaLve5+vNvZO0l7Nq5ja3MPhbw/Zy0/wgqCgHFNdKS3cxS/4qNYhNLqDue4ooc
         J5EXd9M3CGckvr5AeCg01H05bHqrWl9oIldXxZyKGqNhqjj4kHaNhCQp1c7egMM531/g
         0N6aof8FoDZ0/n1nLpXmasPJ3LYaX/UAhpwEXGBjpWrXiOyYtqQVHTcsdM7gm/cVbdTY
         W13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R0W5fcABi4X+T/jYwfg3acG+mAXpKXLqoOLMcVDvb94=;
        b=jX14jzqAF3pYbq7tejKteJkVllpNYrCfdzovURif1DoqVmLm51+szfnVupBoiGqgSa
         XHAT43dbyK6BVdguEMOK+VsPetkSeEeG/g9ZdRYuCgT9ejIOd+MbCt5z+rEwpJWL8mQS
         bp95mIBktdCX16MfCT4fDn15ANpJFGC/duTr/x2PbKsOkihZhn+4aqanSGFdkDLyq5Xs
         pd5YsTzbPrjz5M6d0XwD8iN4qqSUan4Avafh0T1Lwl1EwByIF6wZOB/klCFS0smoL5Iy
         Cs8JdvQD6SGPM4z6r08XOI+DAF83KmxYCnjJ93eE2EcNjIgEz22hdEtOldlvmn7BEHc4
         JvPQ==
X-Gm-Message-State: ANoB5plBtOxaSUCO1c/UZHdLjtu3Y/PTjoJ7FEPV49/tGwPedaayDCiF
	5IkcWN16TeOpBJe5Ce/SZ8SvYQ==
X-Google-Smtp-Source: AA0mqf7592VdpFGEsXHXafhoIIzr0OlDlMvX/sxUwlVGqoBDiQgVEZPiR3YzSXTZCX1tcoMfJ2vdoQ==
X-Received: by 2002:a17:902:d491:b0:189:858f:b5c0 with SMTP id c17-20020a170902d49100b00189858fb5c0mr1689887plg.0.1670548137442;
        Thu, 08 Dec 2022 17:08:57 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902d2c600b00189e1522982sm51067plc.168.2022.12.08.17.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 17:08:57 -0800 (PST)
Date: Fri, 9 Dec 2022 01:08:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: selftests: Setup ucall after loading program
 into guest memory
Message-ID: <Y5KKpQSd8H88vDoH@google.com>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
 <20221207214809.489070-3-oliver.upton@linux.dev>
 <Y5EoZ5uwrTF3eSKw@google.com>
 <Y5EtMWuTaJk9I3Bd@google.com>
 <Y5EutGSjkRmdItQb@google.com>
 <Y5Exwzr6Ibmmthl0@google.com>
 <Y5IxNTKRnacfSsLt@google.com>
 <Y5I0paok+dvTtrkt@google.com>
 <Y5I/xiFMLVbpAZj+@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5I/xiFMLVbpAZj+@google.com>
Message-ID: <20221209010853.eyK2EDa5UqLVmdZ6wEHREvlGhmSoTSZWh1s2jLRIBdw@z>

On Thu, Dec 08, 2022, Ricardo Koller wrote:
> On Thu, Dec 08, 2022 at 07:01:57PM +0000, Sean Christopherson wrote:
> > On Thu, Dec 08, 2022, Ricardo Koller wrote:
> > > On Thu, Dec 08, 2022 at 12:37:23AM +0000, Oliver Upton wrote:
> > > > On Thu, Dec 08, 2022 at 12:24:20AM +0000, Sean Christopherson wrote:
> > > > > > Even still, that's just a kludge to make ucalls work. We have other
> > > > > > MMIO devices (GIC distributor, for example) that work by chance since
> > > > > > nothing conflicts with the constant GPAs we've selected in the tests.
> > > > > > 
> > > > > > I'd rather we go down the route of having an address allocator for the
> > > > > > for both the VA and PA spaces to provide carveouts at runtime.
> > > > > 
> > > > > Aren't those two separate issues?  The PA, a.k.a. memslots space, can be solved
> > > > > by allocating a dedicated memslot, i.e. doesn't need a carve.  At worst, collisions
> > > > > will yield very explicit asserts, which IMO is better than whatever might go wrong
> > > > > with a carve out.
> > > > 
> > > > Perhaps the use of the term 'carveout' wasn't right here.
> > > > 
> > > > What I'm suggesting is we cannot rely on KVM memslots alone to act as an
> > > > allocator for the PA space. KVM can provide devices to the guest that
> > > > aren't represented as memslots. If we're trying to fix PA allocations
> > > > anyway, why not make it generic enough to suit the needs of things
> > > > beyond ucalls?
> > > 
> > > One extra bit of information: in arm, IO is any access to an address (within
> > > bounds) not backed by a memslot. Not the same as x86 where MMIO are writes to
> > > read-only memslots.  No idea what other arches do.
> > 
> > I don't think that's correct, doesn't this code turn write abort on a RO memslot
> > into an io_mem_abort()?  Specifically, the "(write_fault && !writable)" check will
> > match, and assuming none the the edge cases in the if-statement fire, KVM will
> > send the write down io_mem_abort().
> 
> You are right. In fact, page_fault_test checks precisely that: writes on
> RO memslots are sent to userspace as an mmio exit. I was just referring
> to the MMIO done for ucall.

To clarify for others, Ricardo thought that x86 selftests were already using a
read-only memslot for ucalls, hence the confusion.

> Having said that, we could use ucall as writes on read-only memslots
> like what x86 does.

+1.  x86 currently uses I/O with a hardcoded port, but theoretically that's just
as error prone as hardcoding a GPA, it just works because x86 doesn't have any
port I/O tests.

Ugh, and that made me look at sync_regs_test.c, which does its own open coded
ucall.  That thing is probably working by dumb luck at this point.
