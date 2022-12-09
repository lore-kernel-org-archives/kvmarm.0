Received: from out-233.mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAEDA3F
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 09:39:54 +0000 (UTC)
Date: Fri, 9 Dec 2022 08:29:08 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Message-ID: <Y5Lx1KhQvqtAvHoc@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209082423.yideydkw6ig6x5zg@kamzik>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209082423.yideydkw6ig6x5zg@kamzik>
Message-ID: <20221209082908.O85aeemg23jm43pq0f2ilR5sduJN0RTBq7RVDQMdtf0@z>

On Fri, Dec 09, 2022 at 09:24:23AM +0100, Andrew Jones wrote:
> On Fri, Dec 09, 2022 at 01:52:59AM +0000, Oliver Upton wrote:
> > base-commit: 89b2395859651113375101bb07cd6340b1ba3637
> 
> This commit doesn't seem to exist linux-next or kvm/queue, but the patch
> context seems to match up with linux-next pretty well. Anyway,

Ah, a force push to kvm/queue likely explains it :) I believe Paolo has
taken the first two patches in his merge resolution now on kvm/next.

> For the series
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks!

--
Best,
Oliver
