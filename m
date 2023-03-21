Received: from out-4.mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB3C952
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 15:41:26 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679413284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lr99MdUxeITw8WKW3Op9CI7vhUTKNyR5Xxk35MsXtkY=;
	b=K8GiLgH6InfTdlEfwko0HNjhfg6bRvN2yWZ38JW3kHieQ8WYSKBXNFsxf5f3NSIXiOlL8c
	Pzs9xEeAJ5P7IohAvofX1qUzPsuMO+s8TRGDBYpL/ydqMwqyv7GRTqo/5kKVAwCtOi0lvX
	3WKS+ntoCz0Ck0JoI1vsBoLIuxPPGLA=
From: Andrew Jones <andrew.jones@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/pl031: Apply gic_enable_irq
Date: Tue, 21 Mar 2023 16:41:21 +0100
Message-Id: <167940943515.820115.9141431593106192065.b4-ty@linux.dev>
In-Reply-To: <20230321121325.755595-1-andrew.jones@linux.dev>
References: <20230321121325.755595-1-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 21 Mar 2023 13:13:25 +0100, Andrew Jones wrote:
> Use gic_enable_irq() to clean up code.
> 
> 

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
