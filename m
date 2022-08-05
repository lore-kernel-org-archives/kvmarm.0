Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA93C00140
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 10:41:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 535644DE30;
	Fri,  5 Aug 2022 06:41:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uMOA18wkOw+d; Fri,  5 Aug 2022 06:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 718CE4DE21;
	Fri,  5 Aug 2022 06:41:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E1114DDFB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 06:41:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EI9rbjIBsa75 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Aug 2022 06:41:41 -0400 (EDT)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D2964DDC6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Aug 2022 06:41:41 -0400 (EDT)
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=OTPPUyGGnsXSPy11dtQS+LDAKi3g34jl+1S7KkTg4c/j4NTHRlvSZ61Qyy9xzAP31t+Q+wLwm35FGn9MQR87t33BZIcU/4QsGo+UkpJ8EflAXL+T5Z4VPqQ/5K05Wkw6pg63UtdxtNp98fW2ii6wsRBvVgkQXJRD6rXvZDVNBmA9zLQ22RbSI6331zFUyAsXjlyeEW2VLfNxG7OJO3aI4eP7t1JS8q+SEn3iw0wikF8i/RUQjgr0/U154r2acSslwaSXqbjKpQYKfsPxSEZzKRbh8TjzEcCZw41zwYSvI66Qh6ooS8TL0gI8TYmF3e7MTyPBAcx9Uhe9ZdJZOXsUlA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH149LJ8cdZKoKa3T2xgUT9K+OIR6R3Jv5cuj1kBNx8=;
 b=b7tE8IMNjsysc3mPy/Iz9gq566G9xSQZOEfkqFYdjNYszA9wf4picBWbQtJTIzpbM1Zkgq0/4032EY2V31hjRz/3NtGsf3qRetgUIohp0TQDJVS8K1nzcOKgAF7q4fgksOcpdyKCBBdLftkdUDFkl+6Qj66Hi+PInnJoC4ls10gmKiUbIxLUvSeBaKlS3SKxh5NhchXikiIhqsfNJApiFItzKhpCHhk2RDl2YU7ZQAsSQPAPwoiMjW6CcxUxdBww8lUwAdUy+mpivakzE1noWXHBFFTv3/618BDQOYBJHKQKOuIHPG8v73iVwEgP0wqITzFF4ztbFhjOanFlGi3/yA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=lists.cs.columbia.edu smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH149LJ8cdZKoKa3T2xgUT9K+OIR6R3Jv5cuj1kBNx8=;
 b=kIoZr2ZSNEqakg0nhquLHhOQQFnBt2NNAUDHZ4n3JxHEWLNtgLBnz22Qp001kBHRbnelxDz7MFAR8XmaAqJuLhCreR6gBrzgO9g9vvW3BAKzdPx5fQMbx5doZWe3pEKaIkCstIISY47pzxZWN6OK4oBdAn0pumedFOgKrqOcuJM=
Received: from AS9PR06CA0315.eurprd06.prod.outlook.com (2603:10a6:20b:45b::26)
 by AM9PR08MB7103.eurprd08.prod.outlook.com (2603:10a6:20b:41d::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 10:41:38 +0000
Received: from VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45b:cafe::6c) by AS9PR06CA0315.outlook.office365.com
 (2603:10a6:20b:45b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Fri, 5 Aug 2022 10:41:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT056.mail.protection.outlook.com (10.152.19.28) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16 via Frontend Transport; Fri, 5 Aug 2022 10:41:37 +0000
Received: ("Tessian outbound 63c09d5d38ac:v123");
 Fri, 05 Aug 2022 10:41:37 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0fee75a43e809681
X-CR-MTA-TID: 64aa7808
Received: from ab54989ebfb7.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 4554938C-FA43-4ABA-971C-9D9E36BFA426.1; 
 Fri, 05 Aug 2022 10:41:30 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ab54989ebfb7.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Fri, 05 Aug 2022 10:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmFJa4W8hNcO03DbT6yqbz7NjBGV7EQtpd6b4cf3XVHf82t0Jkp1EIceDJaSA0cHS7tYE7qyrX86TaP4WfTyVkdeTZKqZh9Gwe+u+j3tEbMDlpiCGuAJWxonPJ4ubhYjdYn/ZlaKHx9e03JG/V17QNYLPsSDmXimruUH+SakU7xzefYCnnF5mlPq9CUk2T4iXtIJoVC/P1t937pwM7sfYFTPdd1i9ijNiGif7CSsR+Mqy4kqr1nTAmiZ9IjG4Msq8nEztv4jmJMP1MJNkWpZpmhFuHyE/cQYR5d7kq1LBQqLbXxuiuw5f5ki0qYJdyBdtLbwP0yWkOIXmzW2lV87OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH149LJ8cdZKoKa3T2xgUT9K+OIR6R3Jv5cuj1kBNx8=;
 b=i7KTRuWAuy7wpI6gnIecY0gc93IYdT8LKWlszTiiMIpfyGfEQsh+iUw6WcSX6LAuSIwy41oxaZSnZ0EmMn1alUHHqgmCQamSNF48h5NqQRxQ9Y6Q8uwrJbYi0QBg8huYpGqerh+1cFkChoA8Ic7fnOeF38pBoflqXdn4VMHwSswci9xipf3uIMotNwfABr348Tiku1h56shVqhJeMXVH5stfff1wPz1IJBo1SbXwdv+bdi3xA6Qqr5BVPxtMeHg8nvF3s4MWkZXZfLyZNo1X2xsAR1MvL4AEswTERD2ikQ1GKLa2Kfh/wDaYJy1nECFsTXK/U1kmFAAINiNednidpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH149LJ8cdZKoKa3T2xgUT9K+OIR6R3Jv5cuj1kBNx8=;
 b=kIoZr2ZSNEqakg0nhquLHhOQQFnBt2NNAUDHZ4n3JxHEWLNtgLBnz22Qp001kBHRbnelxDz7MFAR8XmaAqJuLhCreR6gBrzgO9g9vvW3BAKzdPx5fQMbx5doZWe3pEKaIkCstIISY47pzxZWN6OK4oBdAn0pumedFOgKrqOcuJM=
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com (2603:10a6:803:7c::27)
 by AM0PR08MB4051.eurprd08.prod.outlook.com (2603:10a6:208:125::32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 10:41:25 +0000
Received: from VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c]) by VI1PR08MB3485.eurprd08.prod.outlook.com
 ([fe80::e9fc:a0db:993f:829c%4]) with mapi id 15.20.5504.014; Fri, 5 Aug 2022
 10:41:25 +0000
From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "drjones@redhat.com"
 <drjones@redhat.com>
Subject: Re: [PATCH] arm: psci: Add psci-off functionality
Thread-Topic: [PATCH] arm: psci: Add psci-off functionality
Thread-Index: AQHYqLS0QhGIHprrL0iQrENo3u755K2gHj7L
Date: Fri, 5 Aug 2022 10:41:25 +0000
Message-ID: <VI1PR08MB3485B2103821FB09CBF18A0D889E9@VI1PR08MB3485.eurprd08.prod.outlook.com>
References: <20220805101812.400235-1-Nikita.Venkatesh@arm.com>
In-Reply-To: <20220805101812.400235-1-Nikita.Venkatesh@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-MS-Office365-Filtering-Correlation-Id: d0b16973-9ff6-4216-b8bd-08da76cf1314
x-ms-traffictypediagnostic: AM0PR08MB4051:EE_|VE1EUR03FT056:EE_|AM9PR08MB7103:EE_
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: IqETpXuRDeltl9+w/rwXPtmF9927HbJDtir3Rmn+PmbZ8GOl8j76H4VetTiykDg8EWLAcaH0ggc9IBb5nDoUsX0cavl/az52VceKi58WUoNGNaS3jpgtXO1z9rCg7Oi11mq2sdZGKZJPva8uA4sx9Km52D+j1Q3c9PqNTlNfzZ4sdfCYel93RgXNCJH7o4uLEYYmDUU0FHQOQd5B+1F4WMIwMyS6ZMMOYxXcph3sEVNWUD/kSBLeOZh7k1if34563ujTOb3s6XiiGeW+29oW+V/JS2+neO9C30yOJQAhCq4+XSCzWnp1c8oKNYo/O/b+tGH59wQRgQ2l7ANZDiFDfpEz+eW87fzO70/EL+YFn+LbT6uKY5gqufnTXqTQHCGPGRassPeemgJMBHKEin6nBQXe7pzhDLCR+7t2VAlj6kBjAK1o6STOLC6scHt/PwLOZbSXzWI0zbbKvicR8hrv9l/+ExpYghec+rJ1jmQ1UxdT7bXa2sJv5bSVfmALuKN/gi6u/Q9WuNlWAnrYQxN1FWkZceYBLrJlPhEDR/VzEciIacoo9CE4rd3S2s8m2fQzgeGhdLVnEW68GZsAhA5dHH+CeLCwD9Sm6sNZnZsQso8Jbk3X2HWKHqBaFRKDkbq9rOOVfUxwCOfltzgxQVBKeAJu6XpHOqgRD443lwhNo+TntPisdZlZxTPTw/MLYCNIrwhgJO4XH/vHXIFMhUwSHADA7ESKFuU87+/QyogvaEqA5IvcfCNJztDXCt+qqSsMqdmYFJ/uwPXYdD6uUCbR4xTCTqqT8XJm6HUQt7I5E7IOUbCVAHMKnY7CGw9bmY0m
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:VI1PR08MB3485.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(41300700001)(7696005)(9686003)(6506007)(53546011)(26005)(66476007)(38070700005)(66946007)(64756008)(66556008)(76116006)(66446008)(122000001)(4326008)(2906002)(91956017)(8676002)(71200400001)(38100700002)(33656002)(186003)(19627405001)(8936002)(478600001)(83380400001)(52536014)(86362001)(5660300002)(55016003)(316002)(54906003)(110136005);
 DIR:OUT; SFP:1101; 
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4051
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: ef2b2370-3b3c-4968-7b2c-08da76cf0be2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIft4vuHWv9rurgKHxC8m3LAC91YDlvzQwTRahoP1y6a9lH3YwsrEJTPrl9XPQYWeSyOQpWo45umlW6TPoxZmYdPZepcsvBmIbO32hNJm82IMcNKeo7jNZwzThfxHVMS1Dxz51fj8y8O9OUm8oSXCVTH0j5zakuj6FQuBOSkydmsVJEUUSuG1CKLhb0H8iEB0BEXlCdZeNDtqd6vhpN3YoLxutVjmTb+UPzhty2bwD/iSiUoOjhpo0AlOrZpn4yab69azUTZyl3R2QIsdoCNl2CG8mteitpWP/eb0CLMwyx+S+GvhCu7FmWl+XTroQrKiTdC9ta4zcKMhwGL5QzCUc1QgACl+mBke7f+VXznX4Nd8YCli5Azx1juBpPkUAh/2geljEL9hnC9W8kSRjaR+2qFkVfswPRmHK6tQ0PMIPrv9q2nRRSo9T3YdLpqQPxaHCJlOU+HWfnH9TcqxeRS2mR6Kkbogj+YtQEqzcxh9HLu59FnEb94GeWY6HAlzldJef0gJS3dDM/JxMFZcQ5qeW3JSYo0FMTYzxGXS4LkPBAfBFa5fWTVGcbrPPGVq/BN+o/GJZx3sArldXtJIKnwV/ZCpbYQyxE9Zo+ngcPkj0TBhTfwNa5UWVvY3GdxYIFsgJPA8ShtNUxCtjPqNmfz/6mBbOjcNJk8G0FKQgzhXNHUqbKaO2LLlvIToyXev3X0hKLsDU6RukAJ/cHOltbk0V3mfZwKPHwkZMaf0mWq9PAAgQHLxL3O8rFxTsp/8prU4Ne+0/Nhi/Mw7rI0ShjdqENL/o6z5NBcSgf00RVUngfKfKUNB4xqxywTisfWnvuL
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(40470700004)(46966006)(186003)(52536014)(336012)(40480700001)(54906003)(110136005)(5660300002)(8936002)(30864003)(4326008)(33656002)(36860700001)(83380400001)(86362001)(70206006)(8676002)(70586007)(2906002)(316002)(107886003)(47076005)(40460700003)(53546011)(478600001)(82310400005)(81166007)(41300700001)(19627405001)(6506007)(7696005)(356005)(26005)(9686003)(55016003)(82740400003);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 10:41:37.5373 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b16973-9ff6-4216-b8bd-08da76cf1314
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT056.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB7103
Cc: "maz@kernel.org" <maz@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4159901566284742640=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============4159901566284742640==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_VI1PR08MB3485B2103821FB09CBF18A0D889E9VI1PR08MB3485eurp_"

--_000_VI1PR08MB3485B2103821FB09CBF18A0D889E9VI1PR08MB3485eurp_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Kindly ignore this patch, I will resend an updated one. Apologies for the =
=93Disclaimer=94 message. This is not intended.

Regards
Nikita
________________________________
From: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Sent: Friday, August 5, 2022 11:18 AM
To: pbonzini@redhat.com <pbonzini@redhat.com>; drjones@redhat.com <drjones@=
redhat.com>
Cc: kvm@vger.kernel.org <kvm@vger.kernel.org>; kvmarm@lists.cs.columbia.edu=
 <kvmarm@lists.cs.columbia.edu>; Alexandru Elisei <Alexandru.Elisei@arm.com=
>; Suzuki Poulose <Suzuki.Poulose@arm.com>; maz@kernel.org <maz@kernel.org>=
; Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: [PATCH] arm: psci: Add psci-off functionality

From: Nikita Venkatesh <nikita.venkatesh@arm.com>

Add PSCI_CPU_OFF testscase to  arm/psci testsuite. The test uses the
following method.

The primary CPU brings up all the secondary CPUs, which are held in a wait
loop. Once the primary releases the CPUs, each of the secondary CPUs
proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
the status of the call is updated by the secondary CPU in cpu_off_done[].

The primary CPU waits for all the secondary CPUs to update the cpumask
and then proceeds to check for the status of the individual CPU CPU_OFF
request. There is a chance that some CPUs might fail at the CPU_OFF
request and come back and update the status once the primary CPU has
finished the scan. There is no fool proof method to handle this. As of
now, we add a 1sec delay between the cpumask check and the scan for the
status.

The test can be triggered by "cpu-off" command line argument.

Signed-off-by: Nikita Venkatesh <nikita.venkatesh@arm.com>
---
 arm/psci.c        | 87 +++++++++++++++++++++++++++++++++++++++++------
 arm/unittests.cfg |  6 ++++
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index efa0722..5485718 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -12,6 +12,9 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/psci.h>
+#include <asm/delay.h>
+
+#define CPU_OFF_TEST_WAIT_TIME 1000

 static bool invalid_function_exception;

@@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
 }

 static int cpu_on_ret[NR_CPUS];
-static cpumask_t cpu_on_ready, cpu_on_done;
+static bool cpu_off_success[NR_CPUS];
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
 static volatile int cpu_on_start;
+static volatile int cpu_off_start;

 static void cpu_on_secondary_entry(void)
 {
@@ -83,6 +88,19 @@ static void cpu_on_secondary_entry(void)
         cpumask_set_cpu(cpu, &cpu_on_done);
 }

+static void cpu_off_secondary_test(void)
+{
+       int cpu =3D smp_processor_id();
+       while (!cpu_off_start)
+               cpu_relax();
+       /* On to the CPU off test */
+       cpu_off_success[cpu] =3D true;
+       cpumask_set_cpu(cpu, &cpu_off_done);
+       cpu_psci_cpu_die();
+       /* The CPU shouldn't execute the next steps. */
+       cpu_off_success[cpu] =3D false;
+}
+
 static bool psci_cpu_on_test(void)
 {
         bool failed =3D false;
@@ -130,7 +148,56 @@ static bool psci_cpu_on_test(void)
         return !failed;
 }

-int main(void)
+static bool psci_cpu_off_test(void)
+{
+       bool failed =3D false;
+       int cpu;
+
+       for_each_present_cpu(cpu) {
+               if (cpu < 1)
+                       continue;
+               smp_boot_secondary(cpu, cpu_off_secondary_test);
+       }
+
+       cpumask_set_cpu(0, &cpu_off_done);
+
+       report_info("PSCI OFF Test");
+
+       /* Release the CPUs */
+       cpu_off_start =3D 1;
+
+       /* Wait until all are done */
+       while (!cpumask_full(&cpu_off_done))
+               cpu_relax();
+
+       /* Allow all the other CPUs to complete the operation */
+       mdelay(CPU_OFF_TEST_WAIT_TIME);
+
+       for_each_present_cpu(cpu) {
+               if (cpu =3D=3D 0)
+                       continue;
+
+               if (!cpu_off_success[cpu]) {
+                       report_info("CPU%d could not be turned off", cpu);
+                       failed =3D true;
+               }
+       }
+       return !failed;
+}
+
+static void run_default_psci_tests(void)
+{
+       report(psci_invalid_function(), "invalid-function");
+       report(psci_affinity_info_on(), "affinity-info-on");
+       report(psci_affinity_info_off(), "affinity-info-off");
+       if (ERRATA(6c7a5dce22b3)){
+               report(psci_cpu_on_test(), "cpu-on");
+       } else {
+               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5d=
ce22b3=3Dy to enable.");
+       }
+}
+
+int main(int argc, char **argv)
 {
         int ver =3D psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);

@@ -143,15 +210,15 @@ int main(void)

         report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
                                           PSCI_VERSION_MINOR(ver));
-       report(psci_invalid_function(), "invalid-function");
-       report(psci_affinity_info_on(), "affinity-info-on");
-       report(psci_affinity_info_off(), "affinity-info-off");
-
-       if (ERRATA(6c7a5dce22b3))
-               report(psci_cpu_on_test(), "cpu-on");
-       else
-               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5d=
ce22b3=3Dy to enable.");

+       if (argc < 2) {
+               run_default_psci_tests();
+       } else if (strcmp(argv[1], "cpu-off") =3D=3D 0) {
+               report(psci_cpu_off_test(), "cpu-off");
+       } else {
+               printf("Unknown subtest\n");
+               abort();
+       }
 done:
 #if 0
         report_summary();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 5e67b55..02ffbcd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -218,6 +218,12 @@ file =3D psci.flat
 smp =3D $MAX_SMP
 groups =3D psci

+[psci-cpu-off]
+file =3D psci.flat
+groups =3D psci
+smp =3D $MAX_SMP
+extra_params =3D -append 'cpu-off'
+
 # Timer tests
 [timer]
 file =3D timer.flat
--
2.17.1
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

--_000_VI1PR08MB3485B2103821FB09CBF18A0D889E9VI1PR08MB3485eurp_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">
<span style=3D"color:rgb(29, 28, 29);font-family:Slack-Lato, Slack-Fraction=
s, appleLogo, sans-serif;font-size:15px;font-variant-ligatures:common-ligat=
ures;text-align:left;background-color:rgb(255, 255, 255);display:inline !im=
portant">Kindly ignore this patch,
 I will resend an updated one. Apologies for the =93Disclaimer=94 message. =
This is not intended.</span></div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">
<span style=3D"color:rgb(29, 28, 29);font-family:Slack-Lato, Slack-Fraction=
s, appleLogo, sans-serif;font-size:15px;font-variant-ligatures:common-ligat=
ures;text-align:left;background-color:rgb(255, 255, 255);display:inline !im=
portant"><br>
</span></div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">
<span style=3D"color:rgb(29, 28, 29);font-family:Slack-Lato, Slack-Fraction=
s, appleLogo, sans-serif;font-size:15px;font-variant-ligatures:common-ligat=
ures;text-align:left;background-color:rgb(255, 255, 255);display:inline !im=
portant">Regards</span></div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);" class=3D"elementToProof">
<span style=3D"color:rgb(29, 28, 29);font-family:Slack-Lato, Slack-Fraction=
s, appleLogo, sans-serif;font-size:15px;font-variant-ligatures:common-ligat=
ures;text-align:left;background-color:rgb(255, 255, 255);display:inline !im=
portant">Nikita</span></div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Nikita Venkatesh &lt;=
Nikita.Venkatesh@arm.com&gt;<br>
<b>Sent:</b> Friday, August 5, 2022 11:18 AM<br>
<b>To:</b> pbonzini@redhat.com &lt;pbonzini@redhat.com&gt;; drjones@redhat.=
com &lt;drjones@redhat.com&gt;<br>
<b>Cc:</b> kvm@vger.kernel.org &lt;kvm@vger.kernel.org&gt;; kvmarm@lists.cs=
.columbia.edu &lt;kvmarm@lists.cs.columbia.edu&gt;; Alexandru Elisei &lt;Al=
exandru.Elisei@arm.com&gt;; Suzuki Poulose &lt;Suzuki.Poulose@arm.com&gt;; =
maz@kernel.org &lt;maz@kernel.org&gt;; Nikita Venkatesh &lt;Nikita.Venkates=
h@arm.com&gt;<br>
<b>Subject:</b> [PATCH] arm: psci: Add psci-off functionality</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font face=3D"Times New Roman" size=3D"3"><span=
 style=3D"font-size:12pt;"><a name=3D"BM_BEGIN"></a>
<div><font size=3D"2"><span style=3D"font-size:11pt;">From: Nikita Venkates=
h &lt;nikita.venkatesh@arm.com&gt;<br>
<br>
Add PSCI_CPU_OFF testscase to&nbsp; arm/psci testsuite. The test uses the <=
br>
following method.<br>
<br>
The primary CPU brings up all the secondary CPUs, which are held in a wait =
<br>
loop. Once the primary releases the CPUs, each of the secondary CPUs <br>
proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also <br>
the status of the call is updated by the secondary CPU in cpu_off_done[].<b=
r>
<br>
The primary CPU waits for all the secondary CPUs to update the cpumask <br>
and then proceeds to check for the status of the individual CPU CPU_OFF <br=
>
request. There is a chance that some CPUs might fail at the CPU_OFF <br>
request and come back and update the status once the primary CPU has <br>
finished the scan. There is no fool proof method to handle this. As of<br>
now, we add a 1sec delay between the cpumask check and the scan for the <br=
>
status.<br>
<br>
The test can be triggered by &quot;cpu-off&quot; command line argument.<br>
<br>
Signed-off-by: Nikita Venkatesh &lt;nikita.venkatesh@arm.com&gt;<br>
---<br>
&nbsp;arm/psci.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 87 +++++++++++=
++++++++++++++++++++++++++++++------<br>
&nbsp;arm/unittests.cfg |&nbsp; 6 ++++<br>
&nbsp;2 files changed, 83 insertions(+), 10 deletions(-)<br>
<br>
diff --git a/arm/psci.c b/arm/psci.c<br>
index efa0722..5485718 100644<br>
--- a/arm/psci.c<br>
+++ b/arm/psci.c<br>
@@ -12,6 +12,9 @@<br>
&nbsp;#include &lt;asm/processor.h&gt;<br>
&nbsp;#include &lt;asm/smp.h&gt;<br>
&nbsp;#include &lt;asm/psci.h&gt;<br>
+#include &lt;asm/delay.h&gt;<br>
+<br>
+#define CPU_OFF_TEST_WAIT_TIME 1000<br>
&nbsp;<br>
&nbsp;static bool invalid_function_exception;<br>
&nbsp;<br>
@@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)<br>
&nbsp;}<br>
&nbsp;<br>
&nbsp;static int cpu_on_ret[NR_CPUS];<br>
-static cpumask_t cpu_on_ready, cpu_on_done;<br>
+static bool cpu_off_success[NR_CPUS];<br>
+static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;<br>
&nbsp;static volatile int cpu_on_start;<br>
+static volatile int cpu_off_start;<br>
&nbsp;<br>
&nbsp;static void cpu_on_secondary_entry(void)<br>
&nbsp;{<br>
@@ -83,6 +88,19 @@ static void cpu_on_secondary_entry(void)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpumask_set_cpu(cpu, &amp;=
cpu_on_done);<br>
&nbsp;}<br>
&nbsp;<br>
+static void cpu_off_secondary_test(void)<br>
+{<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int cpu =3D smp_processor_id();<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (!cpu_off_start)<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; cpu_relax();<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* On to the CPU off test */<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpu_off_success[cpu] =3D true;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpumask_set_cpu(cpu, &amp;cpu_off_don=
e);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpu_psci_cpu_die();<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* The CPU shouldn't execute the next=
 steps. */<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpu_off_success[cpu] =3D false;<br>
+}<br>
+<br>
&nbsp;static bool psci_cpu_on_test(void)<br>
&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bool failed =3D false;<br>
@@ -130,7 +148,56 @@ static bool psci_cpu_on_test(void)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return !failed;<br>
&nbsp;}<br>
&nbsp;<br>
-int main(void)<br>
+static bool psci_cpu_off_test(void)<br>
+{<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bool failed =3D false;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int cpu;<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for_each_present_cpu(cpu) {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; if (cpu &lt; 1)<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; smp_boot_secondary(cpu, cpu_off_secondary_test);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpumask_set_cpu(0, &amp;cpu_off_done)=
;<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report_info(&quot;PSCI OFF Test&quot;=
);<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Release the CPUs */<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cpu_off_start =3D 1;<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Wait until all are done */<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while (!cpumask_full(&amp;cpu_off_don=
e))<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; cpu_relax();<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Allow all the other CPUs to comple=
te the operation */<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mdelay(CPU_OFF_TEST_WAIT_TIME);<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for_each_present_cpu(cpu) {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; if (cpu =3D=3D 0)<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; continue;<br>
+<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; if (!cpu_off_success[cpu]) {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report_info(&quo=
t;CPU%d could not be turned off&quot;, cpu);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failed =3D true;=
<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; }<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return !failed;<br>
+}<br>
+<br>
+static void run_default_psci_tests(void)<br>
+{<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_invalid_function(), &quot=
;invalid-function&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_affinity_info_on(), &quot=
;affinity-info-on&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_affinity_info_off(), &quo=
t;affinity-info-off&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ERRATA(6c7a5dce22b3)){<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; report(psci_cpu_on_test(), &quot;cpu-on&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; report_skip(&quot;Skipping unsafe cpu-on test. Set ERRATA_6c7a5d=
ce22b3=3Dy to enable.&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
+}<br>
+<br>
+int main(int argc, char **argv)<br>
&nbsp;{<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int ver =3D psci_invoke(PS=
CI_0_2_FN_PSCI_VERSION, 0, 0, 0);<br>
&nbsp;<br>
@@ -143,15 +210,15 @@ int main(void)<br>
&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report_info(&quot;PSCI ver=
sion %d.%d&quot;, PSCI_VERSION_MAJOR(ver),<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; PSCI_VERSION_MINOR(ver));<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_invalid_function(), &quot=
;invalid-function&quot;);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_affinity_info_on(), &quot=
;affinity-info-on&quot;);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report(psci_affinity_info_off(), &quo=
t;affinity-info-off&quot;);<br>
-<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ERRATA(6c7a5dce22b3))<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; report(psci_cpu_on_test(), &quot;cpu-on&quot;);<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else<br>
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; report_skip(&quot;Skipping unsafe cpu-on test. Set ERRATA_6c7a5d=
ce22b3=3Dy to enable.&quot;);<br>
&nbsp;<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (argc &lt; 2) {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; run_default_psci_tests();<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else if (strcmp(argv[1], &quot;cpu-=
off&quot;) =3D=3D 0) {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; report(psci_cpu_off_test(), &quot;cpu-off&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } else {<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; printf(&quot;Unknown subtest\n&quot;);<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; abort();<br>
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;done:<br>
&nbsp;#if 0<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; report_summary();<br>
diff --git a/arm/unittests.cfg b/arm/unittests.cfg<br>
index 5e67b55..02ffbcd 100644<br>
--- a/arm/unittests.cfg<br>
+++ b/arm/unittests.cfg<br>
@@ -218,6 +218,12 @@ file =3D psci.flat<br>
&nbsp;smp =3D $MAX_SMP<br>
&nbsp;groups =3D psci<br>
&nbsp;<br>
+[psci-cpu-off]<br>
+file =3D psci.flat<br>
+groups =3D psci<br>
+smp =3D $MAX_SMP<br>
+extra_params =3D -append 'cpu-off'<br>
+<br>
&nbsp;# Timer tests<br>
&nbsp;[timer]<br>
&nbsp;file =3D timer.flat<br>
-- <br>
2.17.1<br>
</span></font></div>
</span></font></div>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose,
 or store or copy the information in any medium. Thank you.
</body>
</html>

--_000_VI1PR08MB3485B2103821FB09CBF18A0D889E9VI1PR08MB3485eurp_--

--===============4159901566284742640==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============4159901566284742640==--
