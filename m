Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9722A1E1
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646403; cv=none; b=ku68i0w/8MJNdtzXK4WjdeZkDti0FjxgvS9uq2g0D3pzms5gMo8sOkSArhUfMTtTE7WHqx/gY7L2zVv4OObgdCGrkl6bxdBWW23+8OOLkl5rMBL0PO5wIFt7RQT8RFET8LLFVhInYLWi95JncAYb9NMym3vCSs+Cxo6wLFiTs1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646403; c=relaxed/simple;
	bh=tjGmC4vdq68Ucromqv5FIbCkm+7Tf3YJTwA2beefXD0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ll1IO8VMQYJE3tPyw/jLCEuK/HBchTtsHv8a5XjnAdoqq8bimGO+qimK7rHthOmrni+Qi1fiGdnGUxybTfqWObbEiqA26AHnDzrNzaBiY7e94gx7ZncnUFteeYYkrklGjmwiBroZSUpAZ0invqHhNq/m3QGTBSv64ho5MmHkLjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A48F78C43D;
	Thu, 29 Jan 2026 00:26:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 44B0D20027;
	Thu, 29 Jan 2026 00:26:36 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:26:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/30] ring-buffer: Add non-consuming read for
 ring-buffer remotes
Message-ID: <20260128192646.02cf1b28@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-5-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-5-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w83yetxxzut7c8f5ts7rffnwaoyqf9pa
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 44B0D20027
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/rdl/XabBL++DHiZHfOLAsNiVHUmtio3E=
X-HE-Tag: 1769646396-519553
X-HE-Meta: U2FsdGVkX18lKQWYiJxaOCSWK0x0w5aJllREXXSd4bijFpbilRGhh2NpQyQLmmXniCcqsVYArp/P5dvymZnfUr6Tp5GWPmuFEZcJxl5wPHX9XAGSqz+ShetgwprGaKwnteEK7ZjWWJaEHIHNg0ZYgbV9fwe2ZTC3XWzcnLex7lH9r2JWgg7cu2SGUqwPnapdxBYIEXCx1X7ZUaYzliCcW3S1IVfmC2TOhQhqe3ZYuTwwU7NOst3koU+EuoY/Br/jXm7XGu934AopVPBgHF5PWACD0/vQV5DMWOQbmwPlf47IV5FUTU/G6N1KfA/874sOX5SANF/hEC6BDBm9H3lNQB/XQX8vlpEhYCgdhl4jXixh5YHmnKiJ4aMyXPeaTwOtHw7ysFTRSzalwULxGYWvSA==

On Mon, 26 Jan 2026 10:43:53 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Hopefully, the remote will only swap pages on the kernel instruction (via
> the swap_reader_page() callback). This means we know at what point the
> ring-buffer geometry has changed. It is therefore possible to rearrange
> the kernel view of that ring-buffer to allow non-consuming read.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
