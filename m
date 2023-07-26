Received: from out-54.mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED988493
	for <kvmarm@lists.linux.dev>; Wed, 26 Jul 2023 07:34:21 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690356859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9MvyIg4WX4FC4saOAR0a3u/5ZUoJFrgwpLRFuZ3L8NI=;
	b=HxmRlBh1R3Qz04vPLV2HtKiNn073H+nufoyvoEFWHm2to9R0fBsgxoMzjhNOGVO/z7mwJ1
	XKQ+lEBoCAg9+Oy+OSxHIBV69/3M27OchalM19dsr9NXs+/QM2y7OJfD7+VlzYNFgJqjMv
	8EgMZK92lCTk7kAQ/apRhL26O2Ys/Mc=
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date: Wed, 26 Jul 2023 09:34:18 +0200
Message-ID: <169035653885.7626.4349313144140586163.b4-ty@linux.dev>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
References: <20230724073949.1297331-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 24 Jul 2023 03:39:46 -0400, Shaoqin Huang wrote:
> According the talk[1], because the architecture get updated, what used to be a
> RES1 bit becomes a functinal bit. So we can define the name for these bits, this
> also increase the readability.
> 
> [1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman
> 
> v1:
> https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
> Thanks, Eric for the suggestions:
> - Rephrase the commit title in patch 1.
> - Use the _BITULL().
> - Delete the SCTLR_EL1_RES1 and unwind its definition into
> INIT_SCTLR_EL1_MMU_OFF.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
