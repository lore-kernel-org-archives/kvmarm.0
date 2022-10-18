Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98C1FAF
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 07:47:24 +0000 (UTC)
Date: Tue, 18 Oct 2022 10:47:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666079243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ke4w2J4dPe970jTSZLZN8cLPPnUzQU8Z6qS3Lkrav70=;
	b=YC9fUGhUeXTcSyZMEAKTWIKcDRzJRHKx0IbN3ZVNp6BBHCW9o42o8LmMKrxFhifBU/tX+A
	LHyq2wm8Bl0pyy58F85pv55QeARQ4XT5/pVoqW6cV3b0CHQcrLC9fk/2N7s1XQTqvpl9qt
	PkJdPcfa5W5Tna4u9YTlYPakG77WE8s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
	pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
	peterx@redhat.com, ricarkol@google.com, zhenyzha@redhat.com,
	shan.gavin@gmail.com
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate
 memory sizes
Message-ID: <Y05aCJH+BBo+Y+nh@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y03ScGUUCA1KwlLF@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221018074720.iO-7XraHdcbbIzbTiqh5iSjEXf49pBNSVylRV5_6-PA@z>

On Mon, Oct 17, 2022 at 10:08:48PM +0000, Sean Christopherson wrote:
> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
> > > +#define MEM_EXTRA_SIZE		0x10000
> >
> > Also, an expression like "(64 << 10)" is more readable than a "1"
> > with a tail of zeroes (it's easy to add one zero too many or be one
> > zero short).
> 
> +1 to not open coding raw numbers.
> 
> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
> 16KB, 64K, 2MB, 1GB, etc...
> 
> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
> math off of those.

I mean I love boilerplate as much as the next guy, but we can just use
tools/include/linux/sizes.h

--
Thanks,
Oliver
