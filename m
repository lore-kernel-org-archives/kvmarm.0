Received: from out-69.mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640ED3239
	for <kvmarm@lists.linux.dev>; Mon, 13 Feb 2023 20:32:19 +0000 (UTC)
Date: Mon, 13 Feb 2023 19:24:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1676316253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f8nzKSypT68KL9S7YC2rsMZzZ+ktVZK7yILGCTs6YAY=;
	b=DbdN8DhO/C1/6ITgFsNlm1m+xoLq3BFn2K189nDhWf3ZeZlJ6CxRKgaZ5TGSk8ZVC7XfXo
	Xpi7Ga6jCdOnTjIhwMNI+1qrJicA6eZw6rbPFs6yCQvClG4+jadPu1LavoTdlu/nsYppTZ
	QHAg4eVRVglvUMKvQvP+GSgyiZTEAA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: arm64: Add support for KVM_EXIT_HYPERCALL
Message-ID: <Y+qOUw+j/QFptsIF@linux.dev>
References: <20230211013759.3556016-1-oliver.upton@linux.dev>
 <20230211013759.3556016-6-oliver.upton@linux.dev>
 <Y+pe2T2uK2efUNve@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+pe2T2uK2efUNve@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 13, 2023 at 04:01:29PM +0000, Sean Christopherson wrote:
> On Sat, Feb 11, 2023, Oliver Upton wrote:
> > Finally, we need a flag to let userspace know what conduit instruction
> > was used (i.e. SMC vs. HVC). Redefine the remaining padding in
> > kvm_run::hypercall to accomplish this. Let's all take a moment
> > to admire the flowers and see how 'longmode' tied up a full u32 in the
> > UAPI. Weep.
> 
> I don't think it has to, at least not for other architectures.

And surrender the opportunity to write a smartass commit message? I
think not.


> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 55155e262646..7d3ad820d55c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -341,8 +341,14 @@ struct kvm_run {
>                         __u64 nr;
>                         __u64 args[6];
>                         __u64 ret;
> -                       __u32 longmode;
> -                       __u32 pad;
> +                       union {
> +                               /*
> +                                * Long Mode, a.k.a. 64-bit mode, takes up the
> +                                * first 32 flags on x86 (historical sludge).
> +                                */
> +                               __u32 longmode;
> +                               __u64 flags;
> +                       };

You could pull further shenanigans with the x86 residue by guarding
longmode with #ifndef __KERNEL__ and using a macro to raise the
'longmode' flag.

Then we can all pretend it never existed :)

-- 
Thanks,
Oliver
