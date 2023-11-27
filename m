Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357C530F8A
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 15:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 288502F4;
	Mon, 27 Nov 2023 07:08:20 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4905E3F6C4;
	Mon, 27 Nov 2023 07:07:27 -0800 (PST)
Date: Mon, 27 Nov 2023 15:07:24 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev,
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	bristot@redhat.com, vschneid@redhat.com, mhiramat@kernel.org,
	rppt@kernel.org, hughd@google.com, pcc@google.com,
	steven.price@arm.com, anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com, eugenis@google.com, kcc@google.com,
	hyesoo.yu@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 14/27] arm64: mte: Disable dynamic tag storage
 management if HW KASAN is enabled
Message-ID: <ZWSwrKS6EtJMEu1p@raptor>
References: <20231119165721.9849-1-alexandru.elisei@arm.com>
 <20231119165721.9849-15-alexandru.elisei@arm.com>
 <e8f7d855-e5e7-48dd-adce-7c641a561e2b@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f7d855-e5e7-48dd-adce-7c641a561e2b@redhat.com>

Hi,

On Fri, Nov 24, 2023 at 08:54:12PM +0100, David Hildenbrand wrote:
> On 19.11.23 17:57, Alexandru Elisei wrote:
> > To be able to reserve the tag storage associated with a page requires that
> > the tag storage page can be migrated.
> > 
> > When HW KASAN is enabled, the kernel allocates pages, which are now tagged,
> > in non-preemptible contexts, which can make reserving the associate tag
> > storage impossible.
> 
> I assume that it's the only in-kernel user that actually requires tagged
> memory (besides for user space), correct?

Indeed, this is the case. I'll expand the commit message to be more clear about
it.

Thanks,
Alex

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 
