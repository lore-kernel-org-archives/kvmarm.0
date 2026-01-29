Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C677E0E8
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 00:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769646352; cv=none; b=Eg+Yj5TsrXH/xYc4btHVW1T5sclMtj55vbYGCyR3YAcetg67WFN5R5zhgcLnEpSVCZ0RUaQt/5js+hS1hduFTJQSo5e+F2DWUyIyLuvNiFlP4w1JU4vQf1nbBFiGIle4vnJEePS3eqYgn76PJ5WOLgVQFYY9GVfx2Qs7+NQtrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769646352; c=relaxed/simple;
	bh=++mYl3+DulIKwpn8TgsEifPRO5SuGgRy1stcR7ty5BM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2qZsE44YhtJ0xE0wUSCWI1EDKGj3vqcSZkTn+FHwG1w9hQXqKvCmHaAv8u4ex9AID2eUxk+o1DistWlyHz68ds5gTTlBuxwi3KgE/DfWepPgrbiHdw9UvCjj0qfdDy9Eq1QTME9/5FFATUoxM1JmlDe86tXtT6ALmKJeh39RPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7892F8993C;
	Thu, 29 Jan 2026 00:25:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id D35942000D;
	Thu, 29 Jan 2026 00:25:42 +0000 (UTC)
Date: Wed, 28 Jan 2026 19:25:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/30] ring-buffer: Add page statistics to the
 meta-page
Message-ID: <20260128192552.4412c237@gandalf.local.home>
In-Reply-To: <20260126104419.1649811-2-vdonnefort@google.com>
References: <20260126104419.1649811-1-vdonnefort@google.com>
	<20260126104419.1649811-2-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fudyp3u68omqjtrjwctued9i7d45kszb
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D35942000D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Vb56e76rRVvcfu17HINZb47lehiLr1pU=
X-HE-Tag: 1769646342-895400
X-HE-Meta: U2FsdGVkX19JBi9xRS5aP0vJ4+vPJDTT+uwueSCUhMwDCfiNNtLUx0bg5BBggBzmvytIjc8pmbfeH+eXko+zuvQTqD/UhiZjiYg0MKYwG8BQz4h1hoUPtmt0HzUOAC/wetsqCfSLgImrTwJx7/XNIvnFL2W94oyAvRXPxhLUyEBf0DaSauYlljdMuwPHe+wRBfDnWhuSOD5bLH6Kzr9okdLX84HcYFbc3Vs+pc296UnuxWy8uBXbITlhn7Q1TK9cwMEKNOuGg56yT5hjXE6cZQpr1B+b0SRSougPBIM4DE05oUY8u6vlJR6/L0iiWNWi9ZDSB3wa+0l5JJ6nCHCEBBMvbISQ3iHM2x1YRHbKArVhkcvDD6bnlvxcfiUXvw/rNZH7wA65EQMTNVRBVBuDcQ==

On Mon, 26 Jan 2026 10:43:50 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Add two fields pages_touched and pages_lost to the ring-buffer
> meta-page. Those fields are useful to get the number of used pages in
> the ring-buffer.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
