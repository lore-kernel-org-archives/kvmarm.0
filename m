Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785629E0E5
	for <kvmarm@lists.linux.dev>; Wed,  8 Oct 2025 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759942271; cv=none; b=YiMyGh+thQnNnp/RvFh2QxVWEoccVuvCaCwb7lkQaQiQ68jL+41bR5kACuh/UPjMcjWP2LKVDuiGSg3rktZ7Zzy8bGZnp+Pp73ThoYxahNJ4uV1hBD1Ha8o2E1vW+IXZnf0Xv3uKbRlWZExW3H4jRzGpC28JoanwlCK982JS4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759942271; c=relaxed/simple;
	bh=qCvdqWh3DPpfxbQGE+g5mYNSTzs+ojt/MxeyoAGETVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MD0NQ3dpFJ/SJrT5avVLRCVIlQZQpMp0U76qtgi6kqs/maYvGCPhN6Fvi97nCyKgcrK5GrheVSuCtxvgXjMzyN1ZNlRICW/E4T2ELooZKUrupsWkN5qum/Oo/DzmmwMkCuEdGwdw+d+OU+y6/mnpdkjJYGWAoNoiXDH2oJkwqzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=djWFSYF0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="djWFSYF0"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59890Ss5001554
	for <kvmarm@lists.linux.dev>; Wed, 8 Oct 2025 16:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=maqQv8jukNN7H8+OTGdtneuf
	SwQ7FHqm8dGuYbwSXjQ=; b=djWFSYF0eLnlQ9aPUPDcClV45ZH/Jd4EUJ8vNfhW
	DSa7Q+Cvl4c80b6XpZsYvWk2qwpQHhPk0kzOdlwxpIncZfBW90/l8+oW/CQRDiQk
	kUb/GyeV/uyyuUnFog5wezNe/HWuZAjhgGwX65djvkQH9G5DFKHfudiTDociN4fx
	aqjaQ7PVD2mtDnhE/l3qz4Xez0+YE38WQlwRIxQHU45GdtGoGnwgVD8LaYJNaKv0
	LGZOfxEPf58YmhVoz+Og+56uaQyBIu9q/E7CCMZx/g6tOWIllC+V73PV3bxJ9XoX
	M/FoOrJjY4I1Qorfz9YCrpqDJTpNLfFoG3GIlVwVVAXnoQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49juy73a9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 08 Oct 2025 16:51:07 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-269880a7bd9so222615ad.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Oct 2025 09:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759942266; x=1760547066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maqQv8jukNN7H8+OTGdtneufSwQ7FHqm8dGuYbwSXjQ=;
        b=eefw6xS/HWF7v8QDxo9yQ/2C0DxZbF0FPyXw9BjiEh7aNW4diAZCUppD2lJQ/Qq5sc
         uHbuvAIGyWd+tbkCLlBorCTHeok6hWynegIkEEek+OXdC0fOl9VZZj20QMQxwJa7gCHp
         tty4gbI2m4apQpX7aNUUjAoOC4q6IGSOty0wA//8cF6Dwwmfy5vkAQ39QT5+u8bObWOt
         Ym5e2KFIOdxwgBYSqA8Zo0afLy34XCHwzG8lrNvxGXaIHkRARWKTVTF/650W4ZbGl9c1
         12Yv19xdCStBLLWrCoBILV4tVMTXDUxY7KLyyg166K5R+oJX9fr7xX03RRSjW/+FkPYj
         o0WA==
X-Forwarded-Encrypted: i=1; AJvYcCXRhmPYDamHI7hneBvvQ8BVEE8ooBInPRId0O5O09QbJaPlKHeJXn0LBOy4+Bg8zmO3EBdq3wk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSVvA+BzlauW+sEPDE6lPWmhu3ACoFInZ+vXCNU2XUHrb6aKJx
	DyxvTak4bo3Z4gKqiaOZBqUKlCDfYyDoee6CU4wh5WVgzrakSs8g+Kr6Eg1PThfgsUb04YUg4tI
	eS1J1e699Fx+hEHlop1GhK7STATgYXMasjya5lirB9rUTzyOBGNRZK3+RfEo=
X-Gm-Gg: ASbGncu/JhP/WSyrT7ohtmzzLn7ldt16h4ws3J5BpZU2HEblD8lmxwblmw4JvnsfwPp
	ZFF3CuEk6xbgp2JoiStYW5GlNl21LUYsO+TjWj0TnfFfu9yWSGJWS25TX0gDEGyOchJTvfQutUh
	PKH8awlzyagyaw7ZAlVigmTeButapysNcuPuMFyGg37OJOKuMoJHWypfvICgZQQy2mTOWfWJ5Oj
	GU8r59zRSNWYmidneQsp5YyT+DaqT0ZXE7eeyyTva1Nl7WDuvJHTvWG7wWDYttnbomPNGiwhEHF
	3NfpD+DA3lTxRWpTonWbzb1+E4zQo5XmziLkZI6S3JU08Jcu1C6QLE317uvW8QUzgm2VhAxf
X-Received: by 2002:a17:903:910:b0:240:3b9e:dd65 with SMTP id d9443c01a7336-290273eddc4mr57352935ad.38.1759942265850;
        Wed, 08 Oct 2025 09:51:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBnyYw2oUnSj0/vAnQp9qQPbGmtscQ9X7zMVjR7NAsTZxw3H0Mc84Q9Hd7PLjq/ibke+2cdQ==
X-Received: by 2002:a17:903:910:b0:240:3b9e:dd65 with SMTP id d9443c01a7336-290273eddc4mr57352535ad.38.1759942265189;
        Wed, 08 Oct 2025 09:51:05 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f36b67sm2086715ad.90.2025.10.08.09.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 09:51:04 -0700 (PDT)
Date: Wed, 8 Oct 2025 22:20:58 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, alexandru.elisei@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Check cpu_has_spe() before initializing
 PMSCR_EL1 in VHE
Message-ID: <20251008165058.lcwiapdnar6hvw3b@hu-mojha-hyd.qualcomm.com>
References: <20251007182356.2813920-1-mukesh.ojha@oss.qualcomm.com>
 <aOVckTSJET5ORY1n@linux.dev>
 <861pndzn4w.wl-maz@kernel.org>
 <20251008124040.GC77665@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008124040.GC77665@e132581.arm.com>
X-Authority-Analysis: v=2.4 cv=IrITsb/g c=1 sm=1 tr=0 ts=68e6967b cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=b45o4kL6AAAA:8 a=Rx5nSmygbvK2v2nqR1AA:9
 a=CjuIK1q_8ugA:10 a=GvdueXVYPmCkWapjIL-Q:22 a=dhdsR-PFWuPJUldTnwXm:22
X-Proofpoint-GUID: Ksm8IsRoO1TU_jaRB-c3fsHLYHOQEoLM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyOSBTYWx0ZWRfXyhoSifwXxIhw
 /vOwY0l133FUlYPTgcizmvNTnT93zoMOItFsctyv/Keh2NkN1RmylPRIohrUIxihsh3eV3kbfvZ
 /ivnlScWtdK2zpQh90a59AwtIyaazP2GmNc9cnTlbUOsithtI53XwZSUxtXv5X8Hw9PWxnVpeRJ
 omsxQyKjyt0FE7/HFHv0bEKifK0+CkLMvlx036GeGjRvVYauISLP5sIAVWThBDDIUtCvD8238wM
 FLxAcFAcMBHeo5mDdt0L15lMGZGkhuisA7Xst3/TotoCur26nOtoLl6HZsCdB5uPj0Vl2L8vx2m
 ZwCtZKqs7l7F34oNj1n88An2zrhvWT9sCa+S3hUkZj+JH/Ax1NKbDmy76GnWR8U0BGwnyY7pMfx
 7rFBm/2Gx7VAeBYc1PpxV3GExR7P4g==
X-Proofpoint-ORIG-GUID: Ksm8IsRoO1TU_jaRB-c3fsHLYHOQEoLM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_05,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040029

On Wed, Oct 08, 2025 at 01:40:40PM +0100, Leo Yan wrote:
> On Wed, Oct 08, 2025 at 11:46:55AM +0100, Marc Zyngier wrote:
> 
> [...]
> 
> > > > Lets guard the change with cpu_has_spe() check so that it only affects
> > > > the cpu which has SPE feature supported.
> > > 
> > > This could benefit from being spelled out a bit more. In both cases we
> > > check for the presence of FEAT_SPE, however I believe the issue you
> > > observe is EL3 hasn't delegated ownership of the Profiling Buffer to
> > > Non-secure nor does it reinject an UNDEF in response to the sysreg trap.
> > > 
> > > I agree that the change is correct but the rationale needs to be clear.
> > 
> > To me, this smells a lot more like some sort of papering over a
> > firmware bug. Why isn't SPE available the first place?
> 
> TF-a grants permission to non-secure world [1], only access from secure
> world or realm will trap to EL3.
> 
> So yes, it would be good to check if any issue in firmware.

We have our own implementation of EL3 and not using TF-A.

I believe, we should check in a similar way as we are doing for nVHE
case.

if (host_data_test_flag(HAS_SPE))
	write_sysreg_el1(0, SYS_PMSCR);

> 
> Thanks,
> Leo
> 
> [1] https://git.trustedfirmware.org/plugins/gitiles/TF-A/trusted-firmware-a.git/+/refs/heads/master/lib/extensions/spe/spe.c#52

-- 
-Mukesh Ojha
