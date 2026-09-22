Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE674A68A9
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117028; cv=none; b=MDomJQc9grRkUPtLhPe/8T0VMWtFolaCAb7PUu1GhdMmAJwYPYGrAZgFrftBEdaOtRPnm1e1FfS3r6WUT5q2+RY9q+SSbuJwA3nw0CMoWAZAZY6XCu36sWnpGyB/fs5woOvjNCJpUEHyaOnxHoaFk7/+lkeoqvFGrHX0A3drkUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117028; c=relaxed/simple;
	bh=TNq7qZv6We95KhCy65nIeyeboOhZEhkFGiez636Srtw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rWJi6mSwl8sW10/Xz2/LBpfu7mGoMGBJvHqvivxwYqP1VjBQdWAOdMbN0NNl2/j+szglC9te1ooksv/mHktVLNSCRe62MK3L8fiMaaGeZ1EZw6E+1yQ8RZDAA3JadxQs6/hdAzDwqh+R62/0s6V9/2a6WwZ1ahTFEn2G6dU7DxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OFNcuMXm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hu8hP1m1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OFNcuMXm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hu8hP1m1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MJBf4S3897571
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:43:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Kg/OR840iDQhdwyUp7pmwJO/JhoDMeTO5E4K79nehm0=; b=OFNcuMXmh7AGmV10
	knsoRaEgW1DOXMPkqE6axrjTXY+QI16SKZIKboXNKJD8Kc15XTfM8fMpkusI3SQB
	8CH7dzkYILyelxqMjsuIlmXORALfUutonB2Fbs6VKMtVs1roC1vztFKrlov1xzw2
	hXKWqyb3DTdebH1ZTrkH0nzOrORjvr5ikINWS/yib7JiWlHVvjaEGc3nXzWM5Xy5
	MPolplbsyrok+Nnjgow46lGAHmXPvPsy2UkBo7NfGyx9oUoPoIZ1eu4ABfNTyhhl
	IyfCoyKZUh9NeeQ3Wn3tS4pPdM9L3MNv/m2vfUeCK5Npev/TGbIV+aKk4UUutna9
	Mqk5rw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guyma0wp1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:43:42 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3286d2bac04so292979eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790117022; x=1790721822; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Kg/OR840iDQhdwyUp7pmwJO/JhoDMeTO5E4K79nehm0=;
        b=hu8hP1m1HnaMz0zpjPhFHwDshLOnbDzhI/Z8gwZkeF1WyXiKw560GxsGJza75pdnVn
         w3gFFA1Qc9f7K6ZAUb5/kUZXaHpyWDwg94P58owsDSILEvRcppP7OdyeTdl0eVoHFaJc
         WLEVQ/1rh+0ZMvoOaUk9COOe8P8cGUMriToq/etyO9aSLZzDEcV9zGjx+tjNs6sOhNJY
         MJHImty0M1WiShzAiPZqVv5X1ow0NSDaKgojhphFPMsBqDU4Gm9NEIekr+cxgdKHotZt
         0Nf1Qyw13ce3UaWeswyx+O7uF+ILjvmyD5rw6168Hzm5/i62YNIZVLcUAabtMEVJd3rC
         5kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790117022; x=1790721822;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kg/OR840iDQhdwyUp7pmwJO/JhoDMeTO5E4K79nehm0=;
        b=SahhP6Fh1HTS1vmiZDGKPX46RtdlSPdvCA01XsJXU+uOnSMKDLEspbL2GvXcMNipT1
         USIi3peUpCupRHawGAOoHnwaaFGwK3Iitqdy2elsPkDlHvi1K54omU15yF+wkY7Qelxa
         wq9/ggfqkL2WvTG3ImGH81O0nqzrY+I+645QvVGjW+cjAXm0seZ/8obqxXLCzELgDq8d
         M7nTTWdPsozdTmgG6BO6vu35TP+t3W0so51fPiApKYFUtQyYD5EmykNcH9u29BUgMZEC
         aSnApq74iCzEAPyB2mvs8haIHhNs/Np9kD3MYCEnhDN6XYhRlr3yjpRnQtQpPOdyq12D
         wwOA==
X-Forwarded-Encrypted: i=1; AKwUvByKXDiqJZip4b5l6ojAGQKWCcRrXWNMAjn6dfQgy5VGQeaJ/5LzmCT9DrkwqbZe494eICqx/e8=@lists.linux.dev
X-Gm-Message-State: AFuF++mRCehqqLaN72rng7fHFq9zYxsAxeL1re+y/G8Er5cvQQuTmOuo
	w9s1SXnwwt813g+cyNVVQI8dSVwCZ66wgTTVDzyxsguVszIBUAVoP+p2aQ0gB3hM0TkTJ5zdkJu
	6c+2EE3aASexaRA5kchE/4UtKngsxJRbqoetZG/P7YIohlC9CuqZTa6a/Mfs=
X-Gm-Gg: AYBFou1gXbh3qLK4UURsRynbmClPlPlIRFmgrV/wm89831lcx7RH26MD/D+YDpFH4e1
	wkTt//i7UzMOisZ7BTN0/YbIGOrCARc9zZZs/WIGSMLoUQ0ARAtBkccZUZb1lsneChbVmHVZVrd
	Hb3ub9IKtoJ4E1gJoln9PwNEMfigQYlayFpGzCF8+UzhZ+UAArgQuBBdycdaPMGUxwJgDYWdGci
	+qxcjOvcfFAkdgLj9IBu3RSBbCorZKeeiqhaWfqS2v1kl7bTupTgS9AKyuPVTGi0K+9LUz0Ks42
	T/ONHenn3lmhjHFGkib+RrdxgPmHDz/UbJm2iCaiXTV3GhiiFMsW2fl6fsE4dzzyrtcsaOy8hFv
	tmcKNJHgVHq3NkZC2EdSL2WqOfU8wxLTN6tx8nzfQeaz5Y/JReE06sw==
X-Received: by 2002:a05:693c:638c:20b0:33e:3f5b:3ff6 with SMTP id 5a478bee46e88-33e8ca260d7mr785955eec.18.1790117021753;
        Tue, 22 Sep 2026 15:43:41 -0700 (PDT)
X-Received: by 2002:a05:693c:638c:20b0:33e:3f5b:3ff6 with SMTP id 5a478bee46e88-33e8ca260d7mr785932eec.18.1790117021259;
        Tue, 22 Sep 2026 15:43:41 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96258978sm1124102eec.14.2026.09.22.15.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:43:40 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:43:37 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v19 12/20] KVM: arm64: CCA: Add a new mode for
 supporting Realm guests
Message-ID: <20260922154337.0000762f@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-13-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-13-suzuki.poulose@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: -jHEiYQruz7ltFWyTP1Re89q4bGGqezi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX2PN40t9N5K3V
 L+THarLkB2DWdOMKUL+WFk2H9MzQDJ+Y0qjDYxj28/P9vWq/3HCU8w3TRUpndWqhQQe7eRwDl13
 Ny95jshZT6XFtChiFg50xq8kfGZUI7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX/6mJmlwAveLe
 BYVMgl/CFHWFDBOfcMnjz5mtaHaw5XiaH2bWaI2mbZlieXRz61MKNCEv2QiOASW9CyjBZmtSFED
 w+yp4J1Nud2zsXZzBMDGsnWFDrJFFB5sifDiVvvYHSftwqjnXtEGNx1/HwjI0bVl5K+mtiL5VSC
 /yBYNhNHT78oq0hq3CHjWBdOthXKPwKpzW1A1Q7GtheirGaHe7ROZoNaoT5y4x/uBigRSKf6aDz
 tmLlgih6hmTYTiLle7ZDizFbTuJUhFBVLU8/YzktVBFycaFDpyOi/9B6NgzbAbpjoiZz1sX5z+6
 vhVlf3U3MhxXibyrFHdhTZVEiwSv+kVxRWpXoW40eUajufJEsizCIbgF/hd2nXdwRHSnjSAStOj
 LGkWG/YS/w16JPxMpEsvE3mfoeSPFz8owVX/EjWBi0CbQHyxqQBQEDzvk90Hs4sBqijKqyn1bnK
 3lfW0kXbILrYIhXMseA==
X-Authority-Analysis: v=2.4 cv=N828hG9B c=1 sm=1 tr=0 ts=6ab3049e cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=btJ7bRNyUFryZYO5LPIA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: -jHEiYQruz7ltFWyTP1Re89q4bGGqezi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220303

On Sun, 20 Sep 2026 22:28:37 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Add an explicit mode to support Arm CCA guests.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
FWIW given how simple this is
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Mostly given so I don't read it in v20 :)

Jonathan
