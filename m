Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFB8C1A
	for <kvmarm@lists.linux.dev>; Wed,  7 Dec 2022 21:51:46 +0000 (UTC)
Date: Wed, 7 Dec 2022 21:51:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1670449904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f7P0kqsSYyYgMgn0HVqN0dW/Am5VL47EfwN3CgyuatQ=;
	b=FeI9pWzm2VOlZScgd6p3aQcHP+oSaSJ8yF3rH+FR4l9BzCLgT1bQYaP1BnReWiuavWfgm5
	wP7tt6CQ93A/pW4pC/diMxXscHnyX6h3ovfEmxi9hJvkDYiU61YmoUe6kLx0OfS8AUlKiI
	C8xvBmN8RR1k2bGM6KLUDDk1A5JI/zI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Andrew Jones <andrew.jones@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Ben Gardon <bgardon@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
	Gavin Shan <gshan@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	James Morse <james.morse@arm.com>,
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <pcc@google.com>, Peter Xu <peterx@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Quentin Perret <qperret@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Steven Price <steven.price@arm.com>,
	Usama Arif <usama.arif@bytedance.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Will Deacon <will@kernel.org>,
	Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Message-ID: <Y5EK5dDBhutOQTf6@google.com>
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221207215133.S6WCdMeRvmTJTNGcy1wI-My8zUEhM4YmKcUnKQd1aao@z>

On Tue, Dec 06, 2022 at 06:41:21PM +0100, Paolo Bonzini wrote:
> On 12/5/22 16:58, Marc Zyngier wrote:
> > - There is a lot of selftest conflicts with your own branch, see:
> > 
> >    https://lore.kernel.org/r/20221201112432.4cb9ae42@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201113626.438f13c5@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201115741.7de32422@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201120939.3c19f004@canb.auug.org.au
> >    https://lore.kernel.org/r/20221201131623.18ebc8d8@canb.auug.org.au
> > 
> >    for a rather exhaustive collection.
> 
> Yeah, I saw them in Stephen's messages but missed your reply.
> 
> In retrospect, at least Gavin's series for memslot_perf_test should have
> been applied by both of us with a topic branch, but there's so many
> conflicts all over the place that it's hard to single out one series.
> It just happens.
> 
> The only conflict in non-x86 code is the following one, please check
> if I got it right.
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index 05bb6a6369c2..0cda70bef5d5 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -609,6 +609,8 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
>  				    data_size / guest_page_size,
>  				    p->test_desc->data_memslot_flags);
>  	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
> +
> +	ucall_init(vm, data_gpa + data_size);
>  }
>  static void setup_default_handlers(struct test_desc *test)
> @@ -704,8 +706,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	setup_gva_maps(vm);
> -	ucall_init(vm, NULL);
> -
>  	reset_event_counts();
>  	/*
> 
> 
> Special care is needed here because the test uses ____vm_create().
> 
> I haven't pushed to kvm/next yet to give you time to check, so the
> merge is currently in kvm/queue only.

Have a look at this series, which gets things building and actually
passing again:

https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/

> > - For the 6.3 cycle, we are going to experiment with Oliver taking
> >    care of most of the patch herding. I'm sure he'll do a great job,
> >    but if there is the odd mistake, please cut him some slack and blame
> >    me instead.
> 
> Absolutely - you both have all the slack you need, synchronization
> is harder than it seems.

Appreciated!

--
Thanks,
Oliver
