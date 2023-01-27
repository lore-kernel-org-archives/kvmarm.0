Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA933205
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 23:00:27 +0000 (UTC)
Date: Fri, 27 Jan 2023 23:00:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674860418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mYLdYwB5jQRZGI5iBm1hnHKX7Hrdf384ZZi+I0v+a2E=;
	b=dd4FvyNZJoNCEZzOgoasM4a2U1imL9QCfVRFW7Pr65C3kLUrR3siX06u/knR7paTFV6w/N
	scMYf/OxelgJ7dXa5RxB1+q/E4FxC0pPnFvJTaLAK9sOd14z/nyIl3GuD9Hr4AbdoJBQ2E
	M16QyL10RAH4h3P3mgR0pFFGMa7CTv8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 4/4] KVM: selftests: aarch64: Test read-only PT memory
 regions
Message-ID: <Y9RXfxCiKGZNNV3h@google.com>
References: <20230127214353.245671-1-ricarkol@google.com>
 <20230127214353.245671-5-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127214353.245671-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Ricardo,

On Fri, Jan 27, 2023 at 09:43:53PM +0000, Ricardo Koller wrote:
> Extend the read-only memslot tests in page_fault_test to test
> read-only PT (Page table) memslots. Note that this was not allowed
> before commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
> memslots") as all S1PTW faults were treated as writes which resulted
> in an (unrecoverable) exception inside the guest.

More of a style nit going forward (don't bother respinning):

> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/aarch64/page_fault_test.c    | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index 2e2178a7d0d8..54680dc5887f 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -829,8 +829,9 @@ static void help(char *name)
>  
>  #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)			\
>  {										\
> -	.name			= SCAT3(ro_memslot, _access, _with_af),		\
> +	.name			= SCAT2(ro_memslot, _access),			\

You should explicitly call out these sort of drive-by/opportunistic
changes in the commit message as being just that reviewers don't get
lost figuring out how it relates to the functional change of this
patch.

-- 
Thanks,
Oliver
