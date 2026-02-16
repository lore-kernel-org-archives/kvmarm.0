Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C413016E7
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 10:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771239520; cv=none; b=S2yg2ZedxhcTkpjAzSWvJgkAXU+AvijbclItjTlRTWX7JsNXgHPN2ATSpLwjv3Fqz+PpfEWZEnrVVn60jhXOoz+AUIQIRiwCGQzw3Mg4ZklC4lYTGOLn2IuawI6MZ2H2breI3wg8jZ7ZIqtGcJt1b0bh/Tzl8gYLgj9aCMGZ5/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771239520; c=relaxed/simple;
	bh=gYZB2UYcWMlexhziHcb1jooDUP8Z+ZrOd0c5kK0RKFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXFPn9V9EXWcazjY2g+0JAGbP1Uwv+S5LvUzZO7yfFlWgWXUotlaJtwr0yxOycQcNFgbw+dHLr6Mb/D+9UFwNK43UstyeWqOQRRK8+1JlUgWI3F7BZGHWeJhk6TUx94lvhmsg0ufXn2Wsg5KyK7ywCyuRH3ataOs5gHpWaCd8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=orPkYUKm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OhfIVBUP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="orPkYUKm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OhfIVBUP"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GAWgDG2431215
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 10:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bun9iwrIx5XvoYhhYEOAtScOimlPaUih2JHFachiVsc=; b=orPkYUKmZPIM3dxv
	wE0Y8kQ2zBrodFy2o193HqDKTHkI23WqNTtuZlI+XXl3w8UE8Ak9DpSkMUX6xq48
	5v6yNlYiO2XeRlnie1HIhLjzrFXTVrSw5+kow8mHJxwdYKAaiGsaGJZ/LWSP389M
	nVdmW30fQt1auD4KnE7C+05hbNfBcFr2SpgdUajJ83Pa4k7T6ouptYFDeKQInfUG
	7c98GX4vIHlaKWRWtPmUZ36LPwIIaXVtA/z1MqheR6DpC//MHKJDUzAC4bOXBlDd
	8+GfyIIRuNuPsRlQUJI94h0ioYftJuVFJHQaougzsc49SccPJW2FKEpvzAMp2D/2
	iGi2dQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cahe6488w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 10:58:37 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354e7e705e3so2547460a91.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Feb 2026 02:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771239517; x=1771844317; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bun9iwrIx5XvoYhhYEOAtScOimlPaUih2JHFachiVsc=;
        b=OhfIVBUPB0gN5MtozDyZNzKxJgrey2iirqlVE2r1blNvlLThVsKuTFyC3O51VRaVqK
         sXDhTIQckQ+9zJJK6+X7S9FqYFgg3BIM2YcDb+2ffdwq/dXBu/YzqTo1lryIfhXrwLCu
         mSluJkkDiVN7t3aIDckFoVKeGDPeAkyp1saiNNgLN/lew84s0335nKv8/98V3gIIAqop
         7mzs+Qlq3vslUH+3pSnVoQvS+bSw5d203faqnVsLli4TdNq5sr7TY6ZF23UNU4cZ2vv/
         6w6Y30Wgu3Jd5iQr9wFiHp0aUZ2j30fjxlh7dKrnvy747YTRLIeUqIG6x+ckBhCfQvl9
         ReXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771239517; x=1771844317;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bun9iwrIx5XvoYhhYEOAtScOimlPaUih2JHFachiVsc=;
        b=kanXVIDBkXOva25gZQPstQjSsVRKvtA/8Ivy9xwEpXb85EjmVINuVqVWUiSPFM4YNR
         bFXv8ManKHIiFM/QFu+vODzMx/SaBfLeTFchyLgJK0xwmzLpJw4b1suowdhjAsckGIsY
         xFWd0SEXlQkKmE0iUMVoT7xPD6mtPYvQnJkYy8tNKMRfXGafioW6j16iL7+LqQskZlxO
         Y7SiSbf8Us8ivedUNAZ1fhleC68U0QyovfVDvTBUyh/aThjSeVHLJf3xdmlRw6N3j7Ha
         07NQB/7Ge8R1elHGTztAqNkuWuncnbdIAiQ0NCE31usYKEbU/jScMSh3LD++XyNUkLh7
         ZosA==
X-Forwarded-Encrypted: i=1; AJvYcCUKHndPHns49ZxWSwJMkcT3C3MQlIDILS2vZD/63e66bhE1MC4ibfcoUhmqagwwwLzRnqaK4Ic=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9wu7W7ZdpYIJzqzSDTwrHIZNBgKHA/8QqbicGP7TZ5MW+06b2
	FDYQ/Lm9R2fb8ugbY/FDADVwkWZUwxJgVmxj8ScW0ejQZ6TBRqN+XtWX9sT851xrxQJBMs6gHXD
	ftoHelDo4e6YZpQxIwODAfTu3+Vmswms8EShZWl5AjDZN37B0r051J0k8mMc=
X-Gm-Gg: AZuq6aLgHI5lgE/t3tgnAov9lVx2Zhm7AhYqHiCn3fyGnydQZJGQ1AD2p2JO75Pjfhr
	iN45EM/a3OthCFyQwg+TIZzpOq3C2j8V+1p5bbExsNcpGTbitZvn0u/q83tzEBK3WjUtpFY08+R
	Bumc44uXfh3wspoVjLclyfNBt9DtH1OCsNJROyhWl7ynND6X/Gfj1/7YVBrgTAykmsbAMboQKoZ
	0dJTdOr/EYALS/QIT85++Tk9W+K6hJ+6N4FmP7KXaqgac+1UpnrMm6xe9LeVsy4M1XH6r8r45+2
	orf/neucQXu3Ck5pWhhEjBoq8QGirgT22RvIoAiW42hUX8Gp0LpxrYdw8ql65RWGD0iNeHZ+33b
	2aEDzxxpbXrm31ECvIOMpvnIqXOy6oynDk1WjBt/lbZfSistF517wOlYM6keCVp3ufOD64H5twC
	t0opaRAjIyW869toQ7lwONKWCsIaxeOFIh6PwzEfvQDg==
X-Received: by 2002:a17:90b:5810:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-356aaa76375mr9674724a91.8.1771239516742;
        Mon, 16 Feb 2026 02:58:36 -0800 (PST)
X-Received: by 2002:a17:90b:5810:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-356aaa76375mr9674712a91.8.1771239516272;
        Mon, 16 Feb 2026 02:58:36 -0800 (PST)
Received: from [10.79.192.219] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-356a87f47f1sm5470424a91.8.2026.02.16.02.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 02:58:35 -0800 (PST)
Message-ID: <d2303150-5692-479e-9a56-11a52ba58c2b@oss.qualcomm.com>
Date: Mon, 16 Feb 2026 16:28:29 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/35] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Trilok Soni <trilokkumar.soni@oss.qualcomm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mostafa Saleh <smostafa@google.com>
References: <20260119124629.2563-1-will@kernel.org>
 <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
Content-Language: en-US
From: Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>
In-Reply-To: <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=c5WmgB9l c=1 sm=1 tr=0 ts=6992f85d cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=vdI5acRGcxMedrPici8A:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: qNoZjXdlDKQdZcGOqC_mHEto6WxOEm4J
X-Proofpoint-ORIG-GUID: qNoZjXdlDKQdZcGOqC_mHEto6WxOEm4J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDA5MiBTYWx0ZWRfXw/Hny+2vlCjY
 Kp7j+Egq8DxJqSo6jieiUnAB/rNSJ41gU5VzuVFKL3vgXjkczzPCR3LTcGrsreDz2UUb+n8q4Fs
 Q4LGE90Tnsqz1kRvvXTrBcTMJk3f/7sGipS2Tz6r2/AkAFeqe7BhAOlQt3vzUq0FU1i+UkhDwTA
 mo/X8LRL8lJjMfVZ3Pv22q/05QaHQqwoMgpW1sa4NutTnPX9MvJK6VLj2i77uf0ri785ZGECj+I
 B9rEdqeEI+7hTk+zdiaE9p9wjbakFkY1RqrKDGmq+f6P2GXLhZjBbVV0WPivcV/74ndPZVtvHZD
 BxC3hnfYnD9A99L2+w88Ql/2qIiiidYJsDgYzP5tA480gP7d2+U7yWoCvrjbPeR7Wjohku6k7AY
 1R+jIcVInjJPyM84/laZeohPpP1wlhrAaC7nvYHStnOMu+GdeisUr+VZbesPA46RF7Qa/MGq45A
 k7KzRLp/a83CmvrxC7A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602160092

HI Faud/will,

Can you please share tip of your commits to apply the patch series cleanly?

I could not apply on tip of master branch.

Thanks - Venkat



On 2/11/2026 12:28 AM, Trilok Soni wrote:
> On 1/19/2026 4:45 AM, Will Deacon wrote:
>> Hi folks,
>>
>> It's back and it's even bigger than before!
>>
>> Although the first patch has been picked up as a fix (thanks, Oliver),
>> review feedback has resulted in some additional patches being included
>> in the series. If you'd like to see the first version, it's available
>> here:
> 
> Is it possible to test this patch series w/ the QEMU or it will require
> real SOC platform?
> 
> ---Trilok Soni
> 

