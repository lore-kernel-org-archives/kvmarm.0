Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88462514773
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027625; cv=none; b=UxY9HQnRBjXgqTBZewi3zTv9AGDIO0YD9h8xf77q/9OZt6E6OA3rbfpiJS3VD21MiByp6z0TDjt2WtKbX2bpwewYpDh7pTPLI83xVijkJLPHENL1anIC0G0ug/wQ4/BocwS6xphQ7ZD0WZ6szKdqRY9ndBbg45En29TGJnHpyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027625; c=relaxed/simple;
	bh=xk9+H6CvXaIi2b9MCe7qP08mfzgmJlROo6JCtBtDH9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FCjDn96LTYmI6muYRg0rwqxylIltUfTix8Jp2EnLNSVJeLmggyUfNlbbpw/C+0kFLPUmygqdqCGZcVkzIYY68Ou/z1vw4eXOB6+ua79IFNWD83mv78hD682WGCe2WQjg56BZaqGuNtAr5h3xBxKy51Gc/kbPuUd2eh0EjRRYggE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sfrlc1Bh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z1F8JelK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sfrlc1Bh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z1F8JelK"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LKeZ6X2261179
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nCgFELu6kIfcPsQKoSSTfCHDAyLCU7hgN7NBMBE2YJk=; b=Sfrlc1BhVwMkzGmR
	cmMZ3BWRONujILmAX4IVDq7hZ6g+YoOsnH8oDCHIonpP2TydSD4fCHiGcWWdrQzh
	mh2bS8lWSBe8zVt0Tzj5APVjagbBv16VVRG4Ecep0ObquQhVCt8xKFxg+6tJYriu
	ZqMNSeUKkzOKklnPU3g0qsD7XuwuFKXubSS1Lp6hpGSd7DenDSKPpfkDSf4FTwBB
	6gduSi7fZr/t5ouxzILhAyv9Lq2fUy5i/9b7XBlTwM5NlX0G5mJfou/qjGn21rgq
	c1HrR6k0sJl1r2tTufr/9gZnF6qffL6+UgL6rwRhyGgyGLUSOvkqpmLxNnEWmYbF
	IjPzHA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8w7916d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:53:43 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2dd8920c132so81512585ad.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790027623; x=1790632423; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nCgFELu6kIfcPsQKoSSTfCHDAyLCU7hgN7NBMBE2YJk=;
        b=Z1F8JelK246ELEm0F0AZzpqENLHT2s/Svj/4Iekae+y6ULOG79e3kRZyfWx9FZ0HB+
         Iz3xaS6MnO0zBTyUDE92NZyAZ+akK/fYgu6S55UW5LFkUI3mGLlC0gzhuHQnYMVxHmP1
         atf/z+FQeY5JybA++2TA+yEji54XizV8y2IZXFBaFHizQ0gWjyX+m/MLGOwKghmP7V5f
         X6PJk6XUo59ENSe3DtLr9JNfWY+sSzj0PgIuaVs/xnTfAISBXv7ZgI9dCbHoR140v2Ok
         BWeTwY+NbkSbxhD7XBvnnIUf18WWuHe3CodT9w16Mk9JmwKnhPWzHuZ7PsCX+zYLLyu0
         NefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790027623; x=1790632423;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nCgFELu6kIfcPsQKoSSTfCHDAyLCU7hgN7NBMBE2YJk=;
        b=T80I8YBklbLtrChzGzuVNUzp59w+TExRlUb61ze+ZwioNdgwmRDkStndhjFz9B0o6b
         0j1YQ/78acPXRD7WSARq6uudVtrjF2+cOHrQNNmN7SxedBhxOU0j0MOZnAKR87yHDqEL
         HrEjuRlpuO092NTp10ngjWpi8V9dBABgezVGE7QwCFebfuKO4Sqq8T3YV2WWUMQm+zV/
         2bKQezsmdTw0BqnNcB6HceKAcguChljaFFNOXqRveHSVnjEjBQVyTVUsiRBcDgjRzHIQ
         HaFWHbTvbGsdKPrjoa5i8rKCvjyi/1L7Qw7PGecnDdWoIWijtyLGbSFujCsqVvOtjgeW
         PkTA==
X-Forwarded-Encrypted: i=1; AKwUvBzCW+/RbfxaMLcipfD9abKPmAmG7l1AI6PfaUc/x1idXYKEYh6ZsGSP8/RDOeUQR5Y5HXFGoqc=@lists.linux.dev
X-Gm-Message-State: AFuF++khrbto5qg7ssKxMI6ADxhYZcd1ugLkR5GRW9o/BJdIEQbveQsH
	NKCp5CqlaGtHs3X9lrBremScSGXvHbGNPGJ21cn2eid93K/xpMWNgPmkfmE6lZn6qX8qhtivdQy
	YBo88aguvowx0CMA4ycrQ3PNsL9w8HogABtQCNnKrNTBTt//wUsXqzwiMwzI=
X-Gm-Gg: AYBFou0KyNOtxb8cG3fovbtIATN6HHZgSRL3tjyG1csMww3dU+YJXmcqjAM2hsF79D4
	zHZGtV+8mB8dm5RK97mXwFutZu6nZK6Hmmqu17E3nrdGTj5iDW1ytmZiT3199rMvPM8ArrgzY4J
	IbVgPoPtdUIiF4LJJnRAklsO5Z+3ofZD80w8ibrDLkaTUKR1BBfJLyNWH5/kTGV9F8kjvZSF3Nw
	UC5ZANAeZiGASnVSuOfDM3LLRwKNMIrHBpCxuzEA+YWrUakpcmN4h8DoJVJk/U/jDLFvZM5LtuS
	rZ44D5RyGCsXJKzE0tPYaRkL+tmNrigqnrnXjA6gy139CP+lfjwSq1dLJiQQGp9FQdndIA29nY4
	6irnl/c1K9bbzAqUJGTD8G6k9Dw==
X-Received: by 2002:a17:903:2f89:b0:2dd:60d:8b7c with SMTP id d9443c01a7336-2ddb1b1190amr169293995ad.13.1790027622366;
        Mon, 21 Sep 2026 14:53:42 -0700 (PDT)
X-Received: by 2002:a17:903:2f89:b0:2dd:60d:8b7c with SMTP id d9443c01a7336-2ddb1b1190amr169293795ad.13.1790027621908;
        Mon, 21 Sep 2026 14:53:41 -0700 (PDT)
Received: from localhost ([50.35.44.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e5ec16d09sm710143eec.23.2026.09.21.14.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:53:41 -0700 (PDT)
Date: Mon, 21 Sep 2026 14:53:38 -0700
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
Subject: Re: [PATCH v18 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI
 support
Message-ID: <20260921145338.000070e0@oss.qualcomm.com>
In-Reply-To: <20260912083611.2513845-1-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
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
X-Proofpoint-GUID: g6QhfRR_vOb8iCu3jgUnzaw5xBK6tm45
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMxOSBTYWx0ZWRfX6lG2akZf3iVt
 SppzH3uzSF6ZK1AomFWiYsKcKbvsCLXoUF3lAwlf4djq/O0Lbtmsmc7y7f0Gmg9Yq8jK1mXsIlR
 s6bDb6zqF1GvtMfIrOHx49x/RfptNVoDM2f4lajfcUloaUA700fp/Gu2lgsMfEFag4B+Xn2MVj8
 32J8zVAfF84mV4j9uuPAQoWoVWgydFxa0cOI0/1qrKsMJuFhP/Y+ST+Rj1y8O5vrFCNrw717WYS
 l225pSA8pYY/v6dH7B6HnytNWW76cQCgW9UMLK3LtYiIEJO8vNBKHiinluhe1fm4oa59kfwU4rX
 l2xPw1hrqWALEoxbBGQmvbqMuqp8SfR7u9pPETKJGofWgVvd5+t/Vo6tzHImykJW2O+xMQx+Pii
 p3McpJy+Bg1Psg7Rx9a6LsARMwZHX+wNSYdRYQi1+OJucEJRJqaPSVij6Vmjcg+rUN7WrP7/WIW
 tNzIkctK5lMcqtfzA/g==
X-Proofpoint-ORIG-GUID: g6QhfRR_vOb8iCu3jgUnzaw5xBK6tm45
X-Authority-Analysis: v=2.4 cv=Vqi2kO2n c=1 sm=1 tr=0 ts=6ab1a767 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=aNnz9XPx1a4JIXSYt2cE/A==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=7CQSdrXTAAAA:8 a=_lSb5bjROgHUFZFBuPEA:9 a=CjuIK1q_8ugA:10
 a=uG9DUKGECoFWVXl0Dc02:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMxOSBTYWx0ZWRfXwVjEl7TB+yMO
 cgu4Swu5WhZ44XTi3fVkCNCXvHv2wyYaPqFb23lBoKDEQ5Kt4AChFL/y3n13iidr14VDv3AeeST
 blE81g7VC6yNk1GzPZ10EZ3736QXRCQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210319


> 
> [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
> [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v18
Not seeing this branch.  I wanted to sanity check on discussion in the thread and
was being lazy so didn't want to check out the branch I built for review.

J

