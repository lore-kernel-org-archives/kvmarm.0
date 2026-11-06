Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975713;
	b=cMQJgCFCjhkN7Jj2aFuYJPVzvv24iMSHdUkpS2sb0fI0SzBW7hFXbB6DDonQJbGFQbeh
	 zRuw+KE3roQ6B/BZd3DhHD5qe5Kbx1z+6a6PemJXXqb7UiMAczrmnuqHFbSCXu7l3cnh+
	 o+JMmpWKrB6Z1+CvsX62uZGoFG+kW3Oj3GL0mqHcEb6abuzXdct65DdvhNCpeJ7AsiFuz
	 DKneGVXOHWzPGAlWOd2Lb6ufAdmAiWdBliPoCP3cTCaGf8UFSDyASPtywfHG82k5qZDyO
	 IkTlD7PwpZBF8C5m+5I8T+QQ9iHVOFjbwpZl/5EGm3QqZYHMVr4Gj8iJmPCmfVa0hoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975713;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=AgxbqOaoVM9+7Pj0+8CQw7G3IaiuCjj7kRy0IPi5eVg=;
	b=fhxHjUi1cFIGgpc6FohfjVJzo+6oRqQXTkd8bTh/F61ZjwsTqlA7GoFHx9EP6Q4F9Oz+
	 bJhD0n4a23rocOmqnjkFiG6GZXeV4WZIMOiAanmDzU0R9UlEY9dgyOXKmh0PkeMjPFXzj
	 j1PoxR2NTHrHZWm8WiL7ribrwWLBEXMJfn7nI6XPxCsvrLgWuqAXdL4vn73zxwN1d+71E
	 4QMzLpc6QeiAlTJyhnH7ebA6eXStkQZj1tMEX1GesNAODFVIGJlWQzvdUsjYSQ1gptTWw
	 s0YSFeQeo739q36GUwczkQNqkGPlLEE/s0W1cKmxMlQ0dFAmHm103mnF/RsCg+9eUDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.columbia.edu;
	spf=pass smtp.mailfrom=columbia.edu;
	dkim=pass header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b="Ma+/RZzQ";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.139.74
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544CD606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 14:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 544CD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Ma+/RZzQ
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A6DcM2O1329509
	for <kvmarm@lists.linux.dev>; Fri, 6 Nov 2026 09:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps01; bh=AgxbqOaoVM9+7Pj0+8CQw7G3Iaiu
	Cjj7kRy0IPi5eVg=; b=Ma+/RZzQRAikshvpTwR1Eb4FzE9gsBtnnc5LGsWWCojA
	AZBj2PdwgHcwxlq9AD6KjiX1dJ6otI/lgVtK7TMCP/zaJAE2lhFayZbmAfgmLPt5
	QsBoDuhurAzVoZRIaGDQJRkuUX0wYVDr4HDPlJyadIGYaWUH7PVjUPyd2k1URpig
	eymuvPUPbXpWjkZs5IGZlLVwePmBqAqRT4GG1FN9yFOMBpvx/KIYkZZW9mNbSPwG
	ZettMPQWsQeSk3oL5NOxwAjcDI9WVmStSr4smwpckP6Tjg+C/mPR4NgcI6uTWXVH
	SNYmQm8Nkx0cVvB3CE38ko6Rgzr7SVDg7CFcI54aJg==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hs3pcbe2h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:35:10 -0500 (EST)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-869553205a7so10798207b3.1
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 06:35:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793975710; cv=none;
        d=google.com; s=arc-20260327;
        b=RKU6vzG4DD7rHeX4pBYdy1Q2GAcrKf1uH1NhoBE5A2txUKHCxqy22hy+4B86wchs4T
         xqKslWDR0N2chyHe+CJZT1GX6I+kR9SSNCURwNngQlf/D+f21P8EmcL2tLHY8qPAIVNd
         VuEX7oA6FbKLP2BUh/+gi8HvtXjfPlx2IZ1aUPN5eU/kjgnmV0skrP0wV5X5cp9jgfMt
         7ybcS5duH0loTHaTHlMGRBKVCefIeTTELzPr90jB++yX/EOgCau9xgOL+D6Kh/MEMbf8
         PIinJukrG+dPRjZxe2iFgJlosFc7gjAQHuYeODqv4blKghdOtfWym3K+iNCmwi1IFeLJ
         kYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=AgxbqOaoVM9+7Pj0+8CQw7G3IaiuCjj7kRy0IPi5eVg=;
        fh=Htv9q7qgpb6+7vBOvmxma/8myR8LDeT/ln3jyeLsuq0=;
        b=E7SnDb+BWbGLdSv+DVT8t5RmiqH9f3FtsAfOrKHTE2GSY5DOnfd1grFpE7A5PaLmjZ
         D3cNE1jw/oscp3o6OppDEZfOy9IorvAcxMV3RFlNWf1wEDhR3NSspdPIbAo6cuDWxJG+
         oDuQ7lTKb2R9KpKDkXx5aG2gzgrspRcmzLGHm8+3M0bwgo3zQe8cOp69oA0PLIzMYfO7
         S2hovxo4CzrDnkr9U6Eo30KuM9oMqgXS4y4+JQXsvUdIa0uOk7iS1pKuqjWk78wGrBI6
         4CrH5V0OQmNu0Ztem3g9f0Yud2jVVBzZQoL8DBwNpQelMZDyz9tIfktgynsq7gagVRv0
         9qFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975710; x=1794580510;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AgxbqOaoVM9+7Pj0+8CQw7G3IaiuCjj7kRy0IPi5eVg=;
        b=xuScDdi8yOBLtXd3AF32L2DfJyYCXKL7bDte6TWtmioKF92pgXP6a6YPFrOlBfrzHG
         ipfYJs8/yGuv7lwkInW3YdLp7PvKeNSxIQYJ1jZXIa7ndNXCwgTYscyR1ssWPYVVCagw
         WOoLDEIZajBi80cWcI4uDDiKXCBd26Lpey9d1BbVoIlN2rr1W5xuynLJwRAPMEYG6cCI
         qdWcveT/jnaCzt3U+AHLx+0LQjKPDLtOBVXCbWsg6wO63HZuHLBpHt6/rihTjTeBpFzn
         IHRZaHLhCdFw7lJpmseGiBq3+0z0wCO5FB5MAfxqLEVHr1PbZg6QtOcHhOLVS+WFU2Rm
         lIIw==
X-Forwarded-Encrypted: i=1; AL+hErH+KDHgq4F8UgJGCv5NgTMO2rd0XRIYa6Y/oT4XRAmu2L1MPnGtsEgiZVh/umVOwf/vgjSGmsA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/blvDgHgVwifkJeIkGQSd6AZxInQGGxsvsFY4L27oCvi9tZq/o
	Bi4ZA1/hmzsrds9ya4gpyrPlm7GcJJs4h6untOSMWlLVyLDtFaaXeuDqSQrNUl7Vv6k7IOIlaDO
	yQstCTMwwg8FE65ph0Swc0gpAPrUxU5I8TRj0YtuzOl8PpUBvBYSK6LxMAQaj5MnGhBVIr58Gfb
	FTvMVxuYGlcJjzJBSBPiww/dxtR0JI
X-Gm-Gg: AYBFou17M55wbL4sJGKKpO9mxhCiHBodEk/pBHUKDH4D4vq+v4l5b30H9/MkkesumL5
	7WLz0bDcf1PiTPwW87+3vWR1BI5gAZmZ5gSMX0o5z389gZ2ZJP7HevDsdlbVPbN/QIUYr+/U2au
	+KEQMPJTldsxhRmzz965C10W/g5iql148ppgkwqnsx7Stz0Dgy4q2XA21JgW5lCh1NsOSxQoxg4
	I2fbAxyC3VoqeKmnLk3QoXHybY6l7DVRwtpKgiIMlQrD11fr9W2TEvMbcW8tKUZr3VcdH5IxNWX
	Ujnua320RpfoceKBxn5Rx9Sjb8txxMRrzw==
X-Received: by 2002:a05:690c:dc3:b0:8b0:d027:c4f0 with SMTP id 00721157ae682-8b3417cfa5fmr14408517b3.1.1793975710483;
        Fri, 06 Nov 2026 06:35:10 -0800 (PST)
X-Received: by 2002:a05:690c:dc3:b0:8b0:d027:c4f0 with SMTP id
 00721157ae682-8b3417cfa5fmr14408337b3.1.1793975709944; Fri, 06 Nov 2026
 06:35:09 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261105-pin-barrier-v1-1-04ebf118175a@cs.columbia.edu> <CA+EHjTxoNcx4s4L2DRXLu6VydiG2N3OqRYr+kscghp0jVVwg5g@mail.gmail.com>
In-Reply-To: <CA+EHjTxoNcx4s4L2DRXLu6VydiG2N3OqRYr+kscghp0jVVwg5g@mail.gmail.com>
From: Xuheng Li <xuheng@cs.columbia.edu>
Date: Fri, 6 Nov 2026 14:34:58 +0000
X-Gm-Features: AclHuK9bdlU0f_EKHjmsScSdj7QwMgpM5fQzjjzMWksK2dalOcvjFLTPsgJNF-I
Message-ID: <CAPOPQMDYJ7rEHd0W6Re4fs2u3FVf_Qs=5wD_U8DDOccHwaSY3g@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Order a later pinner's accesses after the hyp mapping
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Authority-Analysis: v=2.4 cv=Vs62kO2n c=1 sm=1 tr=0 ts=6aede59e cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=SMIg8bpeATqOEtpUIEIA:9 a=QEXdDO2ut3YA:10 a=kLokIza1BN8a-hAJ3hfR:22
X-Proofpoint-GUID: jhWmyRcYuWGiOFRkSAJ-iMowX8W3gAXQ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA2MDA1OCBTYWx0ZWRfX9e0FOOYHGOLY
 gYU6vSgra8hm4AYRjY0MZ5T1jucMm2nLND3oF7T5pzZ930fay53PQyya3U04uoKFWz22oYLgFAT
 T+F3N4NYX/9M28hb4d/vtURjRi3nmmnKhcGcsEacKR4kyNz1weiV
X-Proofpoint-ORIG-GUID: jhWmyRcYuWGiOFRkSAJ-iMowX8W3gAXQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA2MDA1OCBTYWx0ZWRfX4TgSo9eM5DJ/
 9NlttOcD3deZM6rt70h55nCxzkCWcv9tF6CPn0fH2jPi4NbmA7hzKGrvO6GCRZT0EXET213OHIi
 RqsbC0vIfe6wWw4txx5c5jlCn2VJUPTGY253/o/7tI1soajIwig4+5PieO5T3Q35aaIvM1YqYH4
 F7+BqEVYYaEZpzIIXoV7CklHrVjhnNiT2mohiePDuX82GBlyhn8AQIVDFNzP5IBLDAWTr4qNxog
 xw9b7io4q2RZX5W3uU2miltuNbn6TsyqvvyxSs5v0/7W4r3IpWtBqnMbKhJVHvRu9m4WOAGc3+i
 l7cQx7LDXHIIoE/gQR2X7av9njYJr2gTsYrtKPqKhrFI9S9vOFlrTSeFr79J93t8y16zN0pMiy5
 b7IQO1vPkDN9GGtNl6LcuhOrg6d9QLmZE67z/ttYA6eTJnpeGSx18mc42w6vVr+tTIWaIa031ZD
 7vAdZvQOv7wCVnYrpzQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11957
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 bulkscore=10 lowpriorityscore=10
 clxscore=1011 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611060058

Hi Fuad,

On Fri, Nov 06, 2026 at 12:59:36PM +0000, Fuad Tabba wrote:
> Could you also give a case in the message that a well-behaved host can
> hit? Since 7.4, two vCPUs of one VM can pin struct kvm at the same
> time from the __kvm_adjust_pc hypercall (cf533b4d3630), which then
> reads it on a CPU with MTE.
>
> Either way:
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks for the review. I'll add the __kvm_adjust_pc case in v2: two
vCPUs of one VM pinning struct kvm at the same time, then reading it
on a CPU with MTE.

Thanks,
Xuheng
