Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599142B9B7
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751946092; cv=none; b=UPZUdRVxMkpYcBpGnZXuXEs8znvNkIscRuMDf1j8Ijw0o7YdTxAr0e37RRdWLV+0V3xcAHaYfLX3IxCLAC0o8CzDHy6B2I9+PLMz0+yYMWLz21FIy1B4AJiok8zBA+7E7glJMJl3PTkZrh+T4UAkekcgru1Go6bWqp9GBZjoPcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751946092; c=relaxed/simple;
	bh=ELbn6HSTysOmlExJ2FWdeFqiEisNHyxTYOXRQyGs7zU=;
	h=Subject:Date:Message-Id:Mime-Version:To:From:Cc:References:
	 In-Reply-To:Content-Type; b=pWzuqgmIPoI7wy258R/LgOWsnmbn3z6msX7ryyd6JqxwdL2Qm9YXMxADbsELyK6vM+TxNU+R0YQ+OCY93jbQM8upqftyVe5hixDB9iu4c5fdcKwUU1/kaDodv9qIdCo60jevH5YB8/UkAFZvTdxBbDAJx2wE77usaCqeQvf8gPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=qS/gOdDt; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="qS/gOdDt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1751946083;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JIChZwtf7KFp0wUJEQAWGYcy6kZOQ3nX77/WhXlHmLk=;
 b=qS/gOdDtwms6MeuigxcdrMAhexKDt63xsVN66NCZu4lBk/5Hmx2IT77ogeTHKmNa0oSnwV
 7AnzSYt61yRvXTMvSxz75bA05URXRqWgRMhh/qA5GMlhJ+23+xfC4vs5q9NsZhFx+U78XH
 ueUhxOC8RwojtzqXKAKqcZsoUvXXPhtIFwaZnEbVjyMifyWZqIGsLBzg0VCTKoWfWUkid3
 pKj/qfYoRN+FwuS9mLY7+75PsePxfKF8x6K5Te7eYLI70jgfYlctAMpLDkSOXi2KYqgmPi
 3Dfhs4hTl1jLYNRsf1Y7mVtqjwHlHSNIXpqhNrGeSTzAsz8fDey3l2B09dsEew==
Content-Transfer-Encoding: 7bit
Subject: Re: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch with kvmtool
Date: Tue, 8 Jul 2025 11:41:18 +0800
Message-Id: <2ccbb58b-1993-450e-b9c5-4b7fcb9c80a2@lanxincomputing.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Received: from [127.0.0.1] ([116.237.111.137]) by smtp.feishu.cn with ESMTPS; Tue, 08 Jul 2025 11:41:20 +0800
User-Agent: Mozilla Thunderbird
To: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>, 
	<kvmarm@lists.linux.dev>, <kvm-riscv@lists.infradead.org>
From: "Nutty Liu" <liujingqi@lanxincomputing.com>
Content-Language: en-US
X-Original-From: Nutty Liu <liujingqi@lanxincomputing.com>
Cc: <alexandru.elisei@arm.com>, <cleger@rivosinc.com>, <jesse@rivosinc.com>, 
	<jamestiotio@gmail.com>, "Atish Patra" <atishp@rivosinc.com>
X-Lms-Return-Path: <lba+2686c9361+a4b553+lists.linux.dev+liujingqi@lanxincomputing.com>
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-5-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-5-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8

On 7/4/2025 11:12 PM, Andrew Jones wrote:
> When running on non-arm (e.g. an x86 machine) if the framework is
> configured to use kvmtool then, unlike with QEMU, it can't work.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>

Thanks,
Nutty
> ---
>   arm/run | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 9ee795ae424c..858333fce465 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -97,6 +97,11 @@ function arch_run_kvmtool()
>   {
>   	local command
>   
> +	if [ "$HOST" != "arm" ] && [ "$HOST" != "aarch64" ]; then
> +		echo "kvmtool requires KVM but the host ('$HOST') is not arm" >&2
> +		exit 2
> +	fi
> +
>   	kvmtool=$(search_kvmtool_binary) ||
>   		exit $?
