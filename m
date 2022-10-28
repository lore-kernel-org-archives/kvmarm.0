Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D608C1841
	for <kvmarm@lists.linux.dev>; Fri, 28 Oct 2022 00:32:29 +0000 (UTC)
Date: Fri, 28 Oct 2022 00:32:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666917148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YmQeJUsu3xWIWXWEJHbX8lN5DXqcivPn29z2MMPdCMA=;
	b=MyWcRuNzNwkuj16CNTXC+jJjnEqH0+E3WS2BeUOKoJhjNor/w8u8OJNo1fGDF05Min9dHP
	R098nsQQ4fOxQ5L+NDymxmEm+DD53sFpu+5mGyty69LBiRTWMTb3a/l2z92BwzRy4SLAWb
	tiNpJS/Xls+MAOq/GGH0UTVjX8+S/gI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 05/25] KVM: arm64: Unify identifiers used to
 distinguish host and hypervisor
Message-ID: <Y1sjF2XJ4nd5OKlc@google.com>
References: <20221020133827.5541-1-will@kernel.org>
 <20221020133827.5541-6-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221020133827.5541-6-will@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 20, 2022 at 02:38:07PM +0100, Will Deacon wrote:
> The 'pkvm_component_id' enum type provides constants to refer to the
> host and the hypervisor, yet this information is duplicated by the
> 'pkvm_hyp_id' constant.
> 
> Remove the definition of 'pkvm_hyp_id' and move the 'pkvm_component_id'
> type definition to 'mem_protect.h' so that it can be used outside of
> the memory protection code, for example when initialising the owner for
> hypervisor-owned pages.
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
