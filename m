Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9C517CDC
	for <kvmarm@lists.linux.dev>; Mon, 31 Oct 2022 09:26:04 +0000 (UTC)
Date: Mon, 31 Oct 2022 09:18:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667207937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UNUd2hX0hdMkIdzwLXRZNRwHJG+w0L3BFPgCSF2V2h4=;
	b=CaGONynma9CEbwNZEVDG+yImQsIJB5eeX0/0rXtRLfnfNR59VQBxdGKz6OlFPOb+BKcSaZ
	1R55TELwMkeAGgecUypT465F9EutTVn2+LKfa+q0uToOuYVa05UhmGaWelJJn3Hobqz5kz
	jptzmt0+r8P9aPbHrF1iijrimPgKgtM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
	catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
	pbonzini@redhat.com, peterx@redhat.com, seanjc@google.com,
	james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 3/9] KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL}
 prior to enabling them
Message-ID: <Y1+S9FC6GTpYehwJ@google.com>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-4-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-4-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221031091844.Q9Ct15sC8xohEecIqPpUJkN0MoiS5QmV0WZa9hBn1T0@z>

On Mon, Oct 31, 2022 at 08:36:15AM +0800, Gavin Shan wrote:
> There are two capabilities related to ring-based dirty page tracking:
> KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL. Both are
> supported by x86. However, arm64 supports KVM_CAP_DIRTY_LOG_RING_ACQ_REL
> only when the feature is supported on arm64. The userspace doesn't have
> to enable the advertised capability, meaning KVM_CAP_DIRTY_LOG_RING can
> be enabled on arm64 by userspace and it's wrong.
> 
> Fix it by double checking if the capability has been advertised prior to
> enabling it. It's rejected to enable the capability if it hasn't been
> advertised.
> 
> Fixes: 17601bfed909 ("KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

This patch should be picked up separate from this series for 6.1. The
original patch went through kvmarm and I think there are a few other
arm64 fixes to be sent out anyway.

Marc, can you grab this? :)

--
Thanks,
Oliver
