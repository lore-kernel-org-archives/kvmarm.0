Received: from out-59.mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41AB47017
	for <kvmarm@lists.linux.dev>; Thu,  1 Jun 2023 18:19:59 +0000 (UTC)
Date: Thu, 1 Jun 2023 18:19:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685643597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Op6GWryyUzDSh/WKepUl4rtfgY7HbqCToNhh/giYDNY=;
	b=dQ/1HkU/RBKu633RPJNBoIaUYkKuIykJ3jvYjangcBpqXZoGqUMYL1jddNS96KEhOTxkpT
	/4W/mUB/z7bYkpBBw9AkemuXQ4ypg54hb4NPUAzD/cLFVzQoMYmM0nMlm2FHVpyQhdnhf9
	aZU78Tk8cF5+eTpjBrgUnhm2hhD93BI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
Message-ID: <ZHjhSZFwEc+VfjGk@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-18-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-18-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

Anish,

On Wed, Apr 12, 2023 at 09:35:05PM +0000, Anish Moorthy wrote:
> +7.35 KVM_CAP_ABSENT_MAPPING_FAULT
> +---------------------------------
> +
> +:Architectures: None
> +:Returns: -EINVAL.
> +
> +The presence of this capability indicates that userspace may pass the
> +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> +to fail (-EFAULT) in response to page faults for which the userspace page tables
> +do not contain present mappings. Attempting to enable the capability directly
> +will fail.
> +
> +The range of guest physical memory causing the fault is advertised to userspace
> +through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).

Maybe third time is the charm. I *really* do not like the
interdependence between NOWAIT exits and the completely orthogonal
annotation of existing EFAULT exits.

How do we support a userspace that only cares about NOWAIT exits but
doesn't want other EFAULT exits to be annotated? It is very likely that
userspace will only know how to resolve NOWAIT exits anyway. Since we do
not provide a precise description of the conditions that caused an exit,
there's no way for userspace to differentiate between NOWAIT exits and
other exits it couldn't care less about.

NOWAIT exits w/o annotation (i.e. a 'bare' EFAULT) make even less sense
since userspace cannot even tell what address needs fixing at that
point.

This is why I had been suggesting we separate the two capabilities and
make annotated exits an unconditional property of NOWAIT exits. It
aligns with the practical use you're proposing for the series, and still
puts userspace in the drivers seat for other issues it may or may not
care about.

-- 
Thanks,
Oliver
