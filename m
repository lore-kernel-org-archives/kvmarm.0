Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCFD143C63
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708725090; cv=none; b=UsDrLDuwDfSUdnZpOPDvXdsM4TNV9VBzIbMYz+w6ShxFvBPBSH9WPyqTl8Nsr+WVEk0SELlE6y+qqvPs0MVy4U+PLd4EBcwwvvCiTrEkj1fIo3IeX20uXrLkfZRWfnYE+ug+/fcR+dHSmrr6qpR+ovzfhJfykG3CaHGWEj7a8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708725090; c=relaxed/simple;
	bh=93F5H5ukZQOVSdrcrxmihCLMlpqa5YQe5yss4A+ZmBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNIxrDq68hH5UVbtxm85HtVnpo/L3ZlPx3j9iuB/HVTfi6ZHaNdhhk4GN6z/gopRp/nTSu/1PB52ew5OoWpd7VyLcVoxfDDyO+/eLlSJCmlmuPtnWqz2CnQZJAE5dcNYj1A9gUq4NxUHOqP5T8zl3Nj/zSjJjvKyI2MxVHM4l4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H+lI+Rj8; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H+lI+Rj8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708725085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jUtHteZepb4z50jTNHYGGTGy3lyvRj0SCUA4OkqA8eU=;
	b=H+lI+Rj8l5nTGp5sBTzGuzdI5khJ9NsvrJ3HNWZCOgT40yuj3u48TDv3nLLpO2T8PtfRp/
	YQZBCLCcnw3Pnx5Pqvq7c0TEDoBv1IPwSEDUGIz5MhmRHrQ1Yb9dgp9qA5DNgz/i/+QCeL
	QNq6wIZM3TtiE5phWqnapfnpWDCsG9g=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvmarm@lists.linux.dev,
	aneesh.kumar@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Marc Zyngier <maz@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ene <sebastianene@google.com>,
	naveen.n.rao@linux.ibm.com,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
Date: Fri, 23 Feb 2024 21:51:12 +0000
Message-ID: <170872506304.206263.3199862434632781431.b4-ty@linux.dev>
In-Reply-To: <20240216155941.2029458-1-oliver.upton@linux.dev>
References: <20240216155941.2029458-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 16 Feb 2024 15:59:41 +0000, Oliver Upton wrote:
> The general expectation with debugfs is that any initialization failure
> is nonfatal. Nevertheless, kvm_arch_create_vm_debugfs() allows
> implementations to return an error and kvm_create_vm_debugfs() allows
> that to fail VM creation.
> 
> Change to a void return to discourage architectures from making debugfs
> failures fatal for the VM. Seems like everyone already had the right
> idea, as all implementations already return 0 unconditionally.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
      https://git.kernel.org/kvmarm/kvmarm/c/284851ee5cae

--
Best,
Oliver
