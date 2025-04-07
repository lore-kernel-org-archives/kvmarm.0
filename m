Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C007A2C9A
	for <kvmarm@lists.linux.dev>; Mon,  7 Apr 2025 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744063682; cv=none; b=J/pgrN33NMrPV/XbHWHFABNlhG75U3u6GcDhk3IwKYr5POMvUtMvok+zU+7c6lGidBPtwrYZgP4hJ9KwVRGRslJhKeuN113k+nU6CmpZFksup4Oc8NkWwweKsYN6f39pTAoqJx3I7wwX3OVPnA7sotrrDcAYFPGL3bGoqgGWiSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744063682; c=relaxed/simple;
	bh=ic3Hi+piyleQea6qrT8lr7zrtZ7cudpB2fvAT4DtmiA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwM3SmKqfFTDbR9+lVagZF98YgOZI6N4wNdiqsTMn1D1/LczZ7GhK7G2mBgyVZGDpfWBm+8ovqFJ8lUcy1/qOvuWYqvCJ3TvUv3aO6MvzZWV3b2VVRxEX2+lLOisz1xALlh0gTJHS0m6TxF4tpruQsWtUb1POV0PC57PGgLxX4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qfCRSOkM; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qfCRSOkM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744063677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XnPScX/NAjyVz6+JEGr5QDMpo7liX3mFdulJgUNodLs=;
	b=qfCRSOkMECNTiSrLqst2U3rlzfe1jESwhQJ4yfpXCZ7kgIBOOCZKxXYd7lketdl9vRpIyQ
	qptnoNk3OvZowA8ktf//DR1AEXK0zeXSeuC92EtoimT9QW9LDkxIrSd8I3noDl6c2jxKmo
	bN4WPHIoZKVMVfH99sMyjkJkbyJj7V0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Use acquire/release to communicate FF-A version negotiation
Date: Mon,  7 Apr 2025 15:07:46 -0700
Message-Id: <174406364625.3332785.16419054127617723958.b4-ty@linux.dev>
In-Reply-To: <20250407152755.1041-1-will@kernel.org>
References: <20250407152755.1041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 07 Apr 2025 16:27:55 +0100, Will Deacon wrote:
> The pKVM FF-A proxy rejects FF-A requests other than FFA_VERSION until
> version negotiation is complete, which is signalled by setting the
> global 'has_version_negotiated' variable.
> 
> To avoid excessive locking, this variable is checked directly from
> kvm_host_ffa_handler() in response to an FF-A call, but this can race
> against another CPU performing the negotiation and potentially lead to
> reading a torn value (incredibly unlikely for a 'bool') or problematic
> re-ordering of the accesses to 'has_version_negotiated' and
> 'hyp_ffa_version' whereby a stale version number could be read by
> __do_ffa_mem_xfer().
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Use acquire/release to communicate FF-A version negotiation
      https://git.kernel.org/kvmarm/kvmarm/c/a344e258acb0

--
Best,
Oliver
