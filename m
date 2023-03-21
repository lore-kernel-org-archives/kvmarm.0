Received: from out-20.mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C46C973
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 15:41:28 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679413287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QvxSsq7y3ApZDI5RYQ/vz56iD3el/CYc8dT0qIs1x4g=;
	b=LhVW8jnewR5Veq+X+UClGyUaa9piY8SXqvgR9MowCRyL+1YrxQXosLdTansUI0BW++m2kk
	LGU9MPmq25SXuI/8Zi6unFq29SBV2+c0bt1ow+v6kz0qKIRuK21eqZrpKFae0VMPoLzio9
	100o8ga3OOX9k9YD0XtYCPuABFJD3RM=
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>,
	kvmarm@lists.linux.dev
Cc: "open list:ARM" <kvm@vger.kernel.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date: Tue, 21 Mar 2023 16:41:23 +0100
Message-Id: <167940943514.820115.10265149359868996572.b4-ty@linux.dev>
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
References: <20230303031148.162816-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 2 Mar 2023 22:11:44 -0500, Shaoqin Huang wrote:
> Some tests still use their own code to enable/disable irq, use
> gic_enable/disable_irq() to clean up them.
> 
> The first patch fixes a problem which will disable all irq when use
> gic_disable_irq().
> 
> The patch 2-3 clean up the code by using the macro.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
