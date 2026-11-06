Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975479;
	b=DtAXvk4xM6nMiO5XG6gd6/FkwekpXCBGyMijivlJuXAANnuDufaOWhJIZ/S8cM09vQta
	 ktlYH1MLhZlh9DXJUGN8nzJ62nqmjBWnq/MLRKu+mX7dt75IQE0EF2rxhzt6Eo5R6lO/X
	 SDkh1fnC4xo78b2KgDhtt1pbvZ1Xhd5iBgYDSxhEL0xy96zxbhIXvGN36uJCmKgxept78
	 /srHemWEVtbsSJ2BWmYKWZoVj+hBE/B0Xum6vzGWfiL+vn4yQdoPdqNebnydy7Ard9IH4
	 Iday3Ms4xMYGdWnPG6dZg/JBC85vfVc9xCEMsyhgQkkRRnu1OV8cICSuOZ8YXqMF4Qg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975479;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=3R6UvoeFxFCY/Ej/MVx8n6FebbxoQvB9tmIs9Jv63a0=;
	b=wyM345RNKBRoQ3wNnpNs0oYtGuEeXn36WuTUz6gBmKEsKrJrN87Zr073P5wTA90bAwqu
	 +83JcQvAKE7ApSYmHrajV6ZE27/hbPXDZoARq1Tl08UKgbI0vwAApDhO3IDV0A9eNpXdm
	 OW68TQIRk9jU9gqLhsKrrFs5q3gtRdddNPX4myx87kmqcxhtF9O+opRWvNWFaA5t5IREz
	 rZSG4jtpM9YcFmeFFhSorO/bfzvrItFpm9MrGSBhWS2qO1uMeNsvWZaQ/NgfEwTRSkBxY
	 CgUxfBKjhhrk/P7vmrWLOsGCmlePguYb4njYnpbdbtdgZEPs11iHiQfj2Sc9HfTGdWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5F9606A32C
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:31:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB5F9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6DckZk2279178
	for <kvmarm@lists.linux.dev>; Fri, 6 Nov 2026 09:31:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps01; bh=3R6UvoeFxFCY/Ej/MVx8n6Febbxo
	QvB9tmIs9Jv63a0=; b=A4sAs1iZWsz+Xe7qnrcwmJHgmp9ac6ZISDzRGcUUFnCN
	1ekY1+GBrHwdfo7muahziFncvTiS/aUUFn2amuxZiTcQZ8sUYT/X3aGJdFrVwJ7N
	ztRtKQb/UAIh0oaaVRq7EQGLhUIwUmhcnE3osWp+9zM6x8ml2TKjNmWQFhPkhzom
	rJVbJu82Q+D4UyVTl2gjddviOfvQPXT89j2egh3xYtXn8ZA+EIaEtbW8iKfV9PMf
	aS8+KV5ROBTDRUiw7HAIJki/hMzI9AeVYLas3NK/J9IpLwhgUEgzOQ/xfgSS+6t0
	jWMtkZ5osacwLaefXZggMa9T/on6PKYxogYgRcB2FA==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hs3pcbd5x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:31:14 -0500 (EST)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8b0d978e4faso8430857b3.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:31:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793975474; cv=none;
        d=google.com; s=arc-20260327;
        b=YnD2CBYFuY4ZBqpSRvWstztEP1JWh3BNsJ6MdoL6Mm9MEUTN5i3HsBRpA6zcwAnBuz
         7gDsGMVlbY3T4vuufMNbD1Irwx8TNrUPjW3kSULyfZmCBdJFlprdya7FEN68H40wct8r
         14jh/oh5Tu+Jw7fGmVP3aBIgUxBHh3kFB/TqzelwRbqzUbJ50Pf/bAlJFN9hyKedWcDy
         S4kFeM4AwAz6ooE9lx1sr4ANgLekthTeWk2tDYomsuBpweQOU9mfX+ucO8u4KmVs9YAJ
         2vixtEiujCP4CVz3XPbf/9/nXeWLhM8SHbaVTMKVRBoj4A9O0YshZcK0pCaet1YLwEK4
         M/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=3R6UvoeFxFCY/Ej/MVx8n6FebbxoQvB9tmIs9Jv63a0=;
        fh=yshuNsd5UH4jU13KJ7pjdjW14fkAnfgtFGSMw3ENnd0=;
        b=Xy/cjO3uVCXtTB0zcYAF0fw64RZkY/RrO0Wrl4aMOiUG0GultXqTGUNFm50Nv66683
         ujMzPDY54vueK4Zi6GiRnWSaOtBS3ECJyEIVbYgUy8nOCtT7BUqIZnFp9zjKNy/Pthj/
         pKKvPTsm+FItoIgDpj1nrfKEC1F8p8LSURP7bHf6Y4Egk8Plag8azdXwTwxjpHu50ydm
         GRyT1P+IS3TtffVI8ePJPfRBymG/2+x9NHVo6XctFGoMulxPLeTzYQ9VBlHaSXw1fCmi
         vIFUtMHXMn0Fu94da18+c9W+KXtyDkg8RwRrp3FDXqbbcvj8ee6TdIDdt/dgQNUra7+9
         bbsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975474; x=1794580274;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3R6UvoeFxFCY/Ej/MVx8n6FebbxoQvB9tmIs9Jv63a0=;
        b=ftJy8ePEuHRMfMbYQNqQPDgP/3qTP93+/X508SPxQBlcMsJm/XXS8z03EOWmR4PqEf
         0XZfwV+Kf1OwaQmXLkY44oC/UDaCnElHta408sg9V/YfaBAVgEzLTWqX4b4WK8VTNXUq
         /UtSN8HgcKql72nw1DhpVYjzf3sRGxwI0GZNu3fP5WK9yssMZ/iCTbcHAsr5nratIoOF
         HZhAzNYtg/GIGmWkOTVWoKBn+4A88sOSUC8MEjhnFqtNb/GKqrg2cDflYePna2GgrJW1
         4f8j+T071gpDEutGXk+cuEWiUzRNZX4hzhoYm8iCcmHwDvUzCVFtGfUNfSp0NxHUfK0j
         1rFA==
X-Forwarded-Encrypted: i=1; AL+hErFpCjr6X7Qfp9NSD9leboRexfEsIu/gGNahtqnFiIFJbugW/DVNI2gMrFva0DahmoJeMHhP270=@lists.linux.dev
X-Gm-Message-State: APuU4Z/WBtzWZVgtDuEPV9EbNJ0aVAlwd1i8Bos5VNYVVrQKgl/XviJL
	SH0tKKaS/V/oX/cC4/gqnNvCxgY9U4vRLFRmmTy0koWFGcDBajYePVFF5eOseZH1M0sMhzHXXmI
	W1RmHRkE1qlST/0bWYXHj41kRX3wuaikHQgD/KTHeRdHlxHwkgR8mhDo9/kwhgDphxUR7jlsAF9
	3bypTDFXJIQJ9CL6NEZln4oGIUIavG
X-Gm-Gg: AYBFou1r0xHtEDxynv3NB1S/Qro+Cm3M0HO5TU7Z59HFwl8d5SndTOYNQe8pbWLwIG9
	/PJKvyeCAf9bMPrTdt9We+1m3Mzj+gax5trLQaQ8BeWPEnV4i29pG8jqJyYWOLlBHZJm5HqlGRA
	8XICPaocCajSCAdM8tdSeJPTu/Nla6xj4EIOQ+PBl4/MjR85C3qPgNdkNTLI8hgzsLFdF4/BBsT
	0C4YI44WB2TXFtFZvKH/zwCs1Pj75Scclyru7hj0oVkJzq5enVQ
X-Received: by 2002:a05:690c:8e0d:b0:8a4:aeb2:acfa with SMTP id 00721157ae682-8b341b2eb3fmr12003387b3.54.1793975474012;
        Fri, 06 Nov 2026 06:31:14 -0800 (PST)
X-Received: by 2002:a05:690c:8e0d:b0:8a4:aeb2:acfa with SMTP id
 00721157ae682-8b341b2eb3fmr12003307b3.54.1793975473710; Fri, 06 Nov 2026
 06:31:13 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-hyp-pool-and-map-v2-0-44a6ca90190b@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v2-1-44a6ca90190b@cs.columbia.edu>
 <CA+EHjTxXpA6sCrSmwRJBA=YKGfNP4zs-THhheRHTaq2BfYY-Lw@mail.gmail.com> <au3eALuLVKZ1WXhp@google.com>
In-Reply-To: <au3eALuLVKZ1WXhp@google.com>
From: Xuheng Li <xuheng@cs.columbia.edu>
Date: Fri, 6 Nov 2026 14:31:02 +0000
X-Gm-Features: AclHuK-uSTIad-lvfbjp5wOphNsNX579YiHzXoYmvUtAiDrC6RcBzvikndjQbQU
Message-ID: <CAPOPQMDz32WrE8K0BDVLKbPc_Owx9izjQ+xPsJEJ2Cwy+BNi7Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Compute hyp early-allocation and pool
 sizes in 64 bits
To: Mostafa Saleh <smostafa@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-ORIG-GUID: wN7AJGtJCOtwHTTZA04_9lGbno7CGWBy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX4gcS9VDwimWh
 WzT+Mq1viVQ8wwhNIgxaKbyiWYCKm0ha9eK79AkBgaW++ZuV7ziHeJOaNFudADlgWYvwYQbqZRc
 fho48hEpBQmsCaAZt7sV0ks3qhBPpDA+bU+knM7dJ7SgYNxp3ynaMJNyg3AOSpTNzBZfI02GyX5
 dwR0iPbqhhZeYszZsYM1SIlICNNuIMpjidm/XGMxdv2uYptRnTO2kkopd6DKbqdwu8HmTYCu5IU
 0USFGHOcjrzxZg47PQF64J8AZh00wMYbDBvnGMT6NXQlvFgUQg9tqMDhcPuMHgVFvSlPku0FDQD
 qmy6+fg6AfsIiQ4ZqO2ASGJmW3jk4yVllEAyG+F3+PaqHRPjf7u1mlHd8fhA5haXFIIFHSkC3X6
 ftzWGcCXno6lyO8nY0JhfYej5Bda0swFCNRN6NmYSwX6mX31KjeAAyRwzh7x6K4YJhnsDtckkz8
 UQbq7ae4nSNbtQ1dqVw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1NyBTYWx0ZWRfX98GG7C9ePIhV
 yl0lV7Uwa7o3sCjX8yyW1xiKnc5tFQH2/PMIU6Fag5p8t9cPDyfQ0DmPHFVnlBWX9GSHVbX1zuW
 plIOSeEjp1NGEObCQZ4gJqy4ICjWIf+Y5MFN99erkyeyb0CORJHf
X-Authority-Analysis: v=2.4 cv=V5PoQuni c=1 sm=1 tr=0 ts=6aede4b2 cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=qqJXGgh0nGIGBJ8XPqMA:9 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-GUID: wN7AJGtJCOtwHTTZA04_9lGbno7CGWBy
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11957
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=10 clxscore=1011 priorityscore=1501
 malwarescore=0 bulkscore=10 suspectscore=0 impostorscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611060057

Hi Mostafa, Fuad,

On Fri, Nov 06, 2026 at 02:02:40PM +0000, Mostafa Saleh wrote:
> I was preparing v3 anyway, I can post it today.

Thanks Mostafa, and thanks Fuad for the pointer and the correction.
I'll drop my patch 1 in favour of Mostafa's updated patch. Fuad's
description of what happens (pKVM init failing at the BUG_ON() in
hyp_set_page_refcounted() just below 2 TiB, and in hyp_back_vmemmap()
from 2 TiB up) is more accurate than mine, and the hyp vmemmap
overflows the same way. Mostafa, feel free to reuse any of my commit
message.

Thanks,
Xuheng
