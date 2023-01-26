Received: from out-235.mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5312F538D
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 20:50:17 +0000 (UTC)
Date: Thu, 26 Jan 2023 20:21:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674764506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCSsOa0JEOzhu3a9IEBtJokH+VBhBqNS4dXI8GM6BrQ=;
	b=i/OFi55Kk1Tj0Kbnkwfvkt5xhK41K7otXqMXHyW9PC+97eT58SMprP3IyAXkwxD+HzvAfI
	2rOsQDnYp/lYKzNBFcuBYyaUOsEO0DG6HreD7ssgJPJgzzW7fn4Jku/4QAoTmt/QyTNUey
	6xw2MuMloIX00xPGtvtk1Tw91nAIiz0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
	maz@kernel.org, will@kernel.org, ricarkol@google.com,
	eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
	reijiw@google.com, ardb@kernel.org, Julia.Lawall@inria.fr,
	yuzenghui@huawei.com, seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v2 0/3] Improve dirty ring warning report
Message-ID: <Y9Lg1ESUVJov0WpH@google.com>
References: <20230119234405.349644-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119234405.349644-1-gshan@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 20, 2023 at 07:44:02AM +0800, Gavin Shan wrote:
> It has been known case where no running VCPU context exists when the
> vgic/its tables are saved. There are other two unknown cases where we
> don't have the running VCPU context: (a) restore vgic3 LPI pending
> status. (b) restoring vgic3 pending tables.
> 
> PATCH[1]     adds unified helper vgic_write_guest_lock()
> PATCH[2 - 3] allows no-running-vcpu context for (a) and (b)

Besides the issue with the first patch, for the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
