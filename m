Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50581440E;
	Fri,  4 Aug 2023 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=98qOA2hy/eGle7yAA5GlRvkVWWpa8WdU1Y+K5iryPA0=; b=PnNUDq2PSjSDtK8+kcZ5YTA5uf
	apCqSPjXpn1RgT3/6WRhgG7ykJw/bB8q1375z6sbZIS2TvZVQjaLKU4edBI1b9/3Ye5nJKEaQ6Hyv
	lIc09SVlq7f4kxrLF5yNORL6ft8PRI91e2jwBfbbGefmjzXGubCU9xtzNTPes0g48fK3fmMxGPR3q
	5PtsNA0nu28tO57agCKHP7aJqd8wER1pSdXGusQrNx/lXpnkLmHiL1kof/uq7qYMWAfsZUTahQh2H
	PPxCJHA7jXZzSrP8MdGFJ2/cmEKVC7/FXwjO5TPlPu7UF/uNuF/0LZaDI37Qo5mPomVdhQuygpp1A
	xNh5kZEw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qRzOM-00BKBq-3m; Fri, 04 Aug 2023 18:19:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(Client did not present a certificate)
	by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EF129300235;
	Fri,  4 Aug 2023 20:19:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
	id CB5C92130B4DC; Fri,  4 Aug 2023 20:19:12 +0200 (CEST)
Date: Fri, 4 Aug 2023 20:19:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v2 2/3] list_debug: Introduce inline wrappers for debug
 checks
Message-ID: <20230804181912.GN212435@hirez.programming.kicks-ass.net>
References: <20230804090621.400-1-elver@google.com>
 <20230804090621.400-2-elver@google.com>
 <20230804120308.253c5521@gandalf.local.home>
 <CANpmjNNN6b9L72DoLzu5usGGjLw5Li8rnfu0VuaCsL-p2iKTgg@mail.gmail.com>
 <20230804135757.400eab72@gandalf.local.home>
 <20230804135902.7925ebb6@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804135902.7925ebb6@gandalf.local.home>

On Fri, Aug 04, 2023 at 01:59:02PM -0400, Steven Rostedt wrote:
> On Fri, 4 Aug 2023 13:57:57 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 4 Aug 2023 19:49:48 +0200
> > Marco Elver <elver@google.com> wrote:
> > 
> > > > I've been guilty of this madness myself, but I have learned the errors of
> > > > my ways, and have been avoiding doing so in any new code I write.    
> > > 
> > > That's fair. We can call them __list_*_valid() (inline), and
> > > __list_*_valid_or_report() ?  
> > 
> > __list_*_valid_check() ?
> > 
> 
> I have to admit, I think the main reason kernel developers default to using
> these useless underscores is because kernel developers are notoriously
> lousy at naming. ;-)

Well, that and I detest novella length identifiers.
