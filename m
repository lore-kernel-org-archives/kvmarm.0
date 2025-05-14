Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A89135A53;
	Wed, 14 May 2025 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747247302; cv=none; b=KCDP40LNRXuG9s5You3qPpct+kPYhmAGbU0A1sxvrQdZ3b25tBW+l/hvUj0ys4f4VgEg7WhdyX3mwq9nHD6HROO6E4jaa28MbCahi5FjlKUaGdjDJKSXyjknKl2Ug9YkwZI5P/TGT9Shz51jX9y+DTpNy3LIeso9sx4Hnus2F1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747247302; c=relaxed/simple;
	bh=y81iAgyiKMhMJStgAM3Qcdb+VOU3OBMQu6oTTeFv0zo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYQ+DXlCJTCwiT6I8FQUNbJ7Iyu3hO4xxuJBPoHXb3Zo8aZWzeCxL3c/i6f78qzE0ZGVypSHv8tQAcaLATDTHpcRyrBdpxy/Juh0dazFUChm7CFWTXxHaSS0jW1rKyczZW+qsgEBV0rCaI/RW/zWQO03ya7xMPvy4SfSDXhCGxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CECC4CEE3;
	Wed, 14 May 2025 18:28:20 +0000 (UTC)
Date: Wed, 14 May 2025 14:28:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/24] Tracefs support for pKVM
Message-ID: <20250514142847.50a47e05@gandalf.local.home>
In-Reply-To: <aCTdUQRPjyhpYnmh@google.com>
References: <20250506164820.515876-1-vdonnefort@google.com>
	<20250514133815.78bc2599@gandalf.local.home>
	<aCTdUQRPjyhpYnmh@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 May 2025 19:13:37 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> I probably can send a v5 this week if you wish, unless you prefer to wait a bit
> more for more comments?

Feel free to send them this week, but I'll be on PTO starting tonight, so I
won't look at them until Tuesday.

-- Steve
