Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A09126ED28
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 06:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804877; cv=none; b=f0lu9cjIhvB4OKtPuy46vhHhu0RMjxl+ZE1JGqOBCeb7ftrqf/RSWCOGkjzYGs6PKRXpfesgnUJ/fFHVYmRgPh+rpkZSRABZIs2ghs7rI/MP90twtkFJKACb3rKjpFKikD3uYKdbZdT3iIvLgMyXxumyon2xNVH/UqKdNeyxYqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804877; c=relaxed/simple;
	bh=3dNO5rbuSZ11Bef4qMbxMHM5CXrfRipGzecB44kvIUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+RhtSt1EsXE3RPtmyxiQx0TStr4mhzD8D14IB/wTROVZIqiYHk4rP5tU6whrxUH6s7jYiacOIomF97IQP1ufNDwGZQCQRew3Pd2EK0T+0Uecdpd1SCIF6ymOrNDgQGS59jIpptikV8yukK4w9CNFCqIMxytmmpqj2nQ7MB24X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4jUjoKj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4jUjoKj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768804875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mW8pP14dIZ9h6OGU2CKcs3QTdvvegnlzEVF253nUeTI=;
	b=A4jUjoKj7pbu+6JJSUInwvvA+egky5ognBs+VyXk2fuPbhR1OcnEltEPq8XO3b+2w6gkCe
	cSGtqnMxqDy1m8Ek4NH+oUye0+b6q/bfKKYDoEyR+NaGi6q6aLlGVV9ubX34XWdRu+7eZb
	5o0dHf+u6qB2nCn2rtfJW31Hivte9mo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-7-cvxdrmN_ic_8ryrMq-Rg-1; Mon, 19 Jan 2026 01:41:14 -0500
X-MC-Unique: 7-cvxdrmN_ic_8ryrMq-Rg-1
X-Mimecast-MFC-AGG-ID: 7-cvxdrmN_ic_8ryrMq-Rg_1768804873
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f25a008dbso27515035ad.1
        for <kvmarm@lists.linux.dev>; Sun, 18 Jan 2026 22:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768804873; x=1769409673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mW8pP14dIZ9h6OGU2CKcs3QTdvvegnlzEVF253nUeTI=;
        b=JZLBlB8G/dSXEPtf5gUgfmDPMtTPcSBIUpFvaePUN2rUM31wqaOEzxf/GdQtoAUsr/
         O5hjU6e9FGldx3rqhPZ+UsETalOkimUVuH5zPC2nsxSeprXq3z0fgXWqnMVRc6xZ9Inn
         goCT9YP+/93YdR1M8eRrLUT+hOwRrQrxsoBIu+FFsacYs9dM5tCgxsBRtTct5QfVh+4J
         rrLn7Y8Sl31slVeMKHID0tIPOAWMV1cpePc5V8GclE0dVcTzn5tYHjL9ZWIs6Pb5i8zu
         tTmt7UF1mUaHZy4JlgS/l6dOrSMbOi+VuyTUTkoLj5JHMwEC9wvmWTbc2RTyqBezKbBM
         dckA==
X-Forwarded-Encrypted: i=1; AJvYcCVf2HJXXqaHgOMeVCN0Nnt/QVUTSkmudkNqeYhfEDiGtGEIlkfQHklKePuCKGdDKi+T6RQc/3E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxooZUXJMHKXkO8xBViIkRK6k9kjTiVhXypG2cNmXN3p/C1o6S8
	UZsQBJFaSHDtFKRL86OS3XTMr1L8G60RG4BVPyedcbiBgdUricxRswSXmvdK3gDByrWrezvsuoK
	XqI6/5gIpMBw22aSedYfo2AdcDFZF76UJuKb7ZSzY4ik8z1ALh19krprtUA==
X-Gm-Gg: AZuq6aLxRnHL303XFLdz/+a1KrKZJDjD/H0szlg8jdsvXrlmMLY1WImDo6V0d/aDuSD
	axPjVNboGjnLOvSj4o9t1D6N6ME1SBD/ql1qMZUvim0MoJ9pr//1WXV+bCiqf2P7x0UieTi12gX
	GfLOAaNnRDlc/MlfAUXC7YBZw5bO8Yp9HvtNL7yimaJA6n58n8M/5OWjIALtggf9XJ31+24C9TF
	gKSFaeBx/uMml/MhVR1W5GsnVQ6nvpSdJUQBmmGCC6C7LsBLQB1LEqzF22jJwcj3G7Q6Gv5v43c
	5KuhIPbavYoLkkN8ApP0Fk1M1WUYaPLkE4ylsOiCHnpvz2agglg1p2GT88LMLsC5CZSaz6JM8Rk
	O5AWZqR0d7fI=
X-Received: by 2002:a17:903:1206:b0:2a0:c58b:ed6 with SMTP id d9443c01a7336-2a7188fd7c9mr94199725ad.29.1768804872795;
        Sun, 18 Jan 2026 22:41:12 -0800 (PST)
X-Received: by 2002:a17:903:1206:b0:2a0:c58b:ed6 with SMTP id d9443c01a7336-2a7188fd7c9mr94199415ad.29.1768804872333;
        Sun, 18 Jan 2026 22:41:12 -0800 (PST)
Received: from [10.72.112.128] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190d14cfsm84741095ad.38.2026.01.18.22.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 22:41:11 -0800 (PST)
Message-ID: <a0d81df0-901a-4478-a07d-e9ee61d21300@redhat.com>
Date: Mon, 19 Jan 2026 14:40:59 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/47] arm64: mpam: Add cpu_pm notifier to restore MPAM
 sysregs
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, james.morse@arm.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-10-ben.horgan@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260112165914.4086692-10-ben.horgan@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tNrf6k2WQHIyp5QBA6-T7MaIcvCfctuP0IezMbFwS1w_1768804873
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 12:58 AM, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> The MPAM system registers will be lost if the CPU is reset during PSCI's
> CPU_SUSPEND.
> 
> Add a PM notifier to restore them.
> 
> mpam_thread_switch(current) can't be used as this won't make any changes if
> the in-memory copy says the register already has the correct value. In
> reality the system register is UNKNOWN out of reset.
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>   arch/arm64/kernel/mpam.c | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

