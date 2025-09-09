Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3502D22D4F6
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757425604; cv=none; b=SUIjLnWBP+1tWePmeVdydrSeoJukCQrqRDw+hbB++m/6PXdx6Qte8E4mhZXuL2Wq/EC6X8j9b1MpMYGq1O2tkk7sF/C1VpIJM/cxp/r06lknQkXBlmn1uMCRSWnFX8/RBbZshDNFdOM3T12qxUT90o6OqblID9Lud7RPpyhkA/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757425604; c=relaxed/simple;
	bh=zXP0vgpsslX+xoM+R5u5Z8Qq+cPpKOIF09oVF2DyXdk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsCMP/BQ8Q2bC8XCmaejNgcmyxB3iElh0+Q6xaRA4OjRn72wj2C/H2uy4IY3u0SgRm9ivOrvyS4uRUaU7ilUf7klD3c8x9R6kaciHEnTahYIAgYXdn8pttht0tzrNfz6H5tRfR2HVcPbKqnrZUtkxBFGvtYOYaMmzWFP7dVH7aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 324285951B;
	Tue,  9 Sep 2025 13:39:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 900C62002A;
	Tue,  9 Sep 2025 13:39:40 +0000 (UTC)
Date: Tue, 9 Sep 2025 09:40:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/24] tracing: Add reset to trace remotes
Message-ID: <20250909094028.3265b751@gandalf.local.home>
In-Reply-To: <aMAZMaZJ1_Eny5Ku@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-5-vdonnefort@google.com>
	<20250908193757.079aae76@gandalf.local.home>
	<aMAZMaZJ1_Eny5Ku@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 900C62002A
X-Stat-Signature: wfa3mdrmcbzi14spidjppaqea6aw3qp1
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+E8T0HTQskMKNFMQEhwq4iyvDU75kvHts=
X-HE-Tag: 1757425180-933823
X-HE-Meta: U2FsdGVkX1+Wwks7b6yVoepNeV7TOzWudjuaDH2HvpSyApAYLfX3FbQwoINlsSIJNvKZcFkkzCa70xLZ8yV4M3RgoVBTMxN5wkAN4Tvsgw8YtAsvBOUnzzaGQoIagJtU8jlbuWu7YwTn4neLH9QVlsUmEnxOFj+Ce+XWBl2YeuaS2Co2nBtPDT2dppC4tUtOJR/BNg+CfKupetaSNKi+SIEiMtMc+wVlYX5nkohak+WdMCO/O577kVmfRGQBv0yYCqWaEXG1hBinQi1qPSUlt1pVhygCIsWRDJWGDRHVLOLUYn/A+q+kGxNNxzOWFpeRPlmy68ip0z5ZjM1JDFzumCv8TLnOFVx7

On Tue, 9 Sep 2025 13:10:25 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> > I wonder if we should name the file "reset" to not be confusing to users
> > when they cat the file and it doesn't produce any output.  
> 
> My idea was to keep the exact same interface as the rest of the tracing. I could
> keep that /trace file for compatibility and add /reset?
> 
> "cat trace" could also just returns a text like *** not supported *** ?

If it's never going to be supported, I rather not add it. It not being
there is a sure way of knowing it's not supported. Just adding it because
the normal system has it is actually worse if it doesn't behave the same.

-- Steve
