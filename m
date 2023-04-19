Received: from out-6.mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653182580
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 08:41:40 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681893698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAL5cKdJD52GbjJBtt/2QV2gYrAcEMuOsmINS4xoZFk=;
	b=tufRf45nYih6R+sCvytwBxxJDbWXBzl09Z6qUfbWHU6jo5tOmdd3XGtAye/16f6RSZu9DK
	w95pIwyTHGG8WlML2hQcAP6VMwu2awX7jqvrEr7IFkVX2RlGfL1GueG5p2QVFZ8r3HqcBb
	/QaTAmcTIQBpVkyFDYCRRAeDdqmu3ak=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Mostafa Saleh <smostafa@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	stable@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Make vcpu flag updates non-preemptible
Date: Wed, 19 Apr 2023 08:41:26 +0000
Message-ID: <168189366436.3163688.14802526283160116596.b4-ty@linux.dev>
In-Reply-To: <20230418125737.2327972-1-maz@kernel.org>
References: <20230418125737.2327972-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 18 Apr 2023 13:57:37 +0100, Marc Zyngier wrote:
> Per-vcpu flags are updated using a non-atomic RMW operation.
> Which means it is possible to get preempted between the read and
> write operations.
> 
> Another interesting thing to note is that preemption also updates
> flags, as we have some flag manipulation in both the load and put
> operations.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Make vcpu flag updates non-preemptible
      https://git.kernel.org/kvmarm/kvmarm/c/35dcb3ac663a

--
Best,
Oliver
