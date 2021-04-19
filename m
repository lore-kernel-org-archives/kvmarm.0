Return-Path: <SRS0=F21+=JQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016AAC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 15:38:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5B2E760FEA
	for <kvmarm@archiver.kernel.org>; Mon, 19 Apr 2021 15:38:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B2E760FEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE9D44B56A;
	Mon, 19 Apr 2021 11:38:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@armh.onmicrosoft.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id basW8Eh66NDt; Mon, 19 Apr 2021 11:38:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 088D54B59A;
	Mon, 19 Apr 2021 11:38:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E464B479
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 06:47:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id muGXZ+3hpD09 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Apr 2021 06:47:02 -0400 (EDT)
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-eopbgr30062.outbound.protection.outlook.com [40.107.3.62])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58E114B3DA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Apr 2021 06:47:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9debTXzDLIdfioXqBmvIsaIcqA2u2D36//f4tWY7La4=;
 b=jnv1xxa+w1v+8EhuBrPcGV8N2kzT5ilhoJaHniWyCYn+om6z2jVtrF0FO0FJI0Ly0vyHm4/uxDNbrHlW6Bd/Wfogdg1iCtFYnPOGkEnmSfsD5Nuwi0wFWRtTMpP9cPLGlQVP6ZBFw+uoND+zH7RfuNEgQxUT7Axy5e5MfMhkgEs=
Received: from AM6P193CA0116.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::21)
 by DB8PR08MB5369.eurprd08.prod.outlook.com (2603:10a6:10:11c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Mon, 19 Apr
 2021 10:46:31 +0000
Received: from AM5EUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:85:cafe::62) by AM6P193CA0116.outlook.office365.com
 (2603:10a6:209:85::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend
 Transport; Mon, 19 Apr 2021 10:46:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.cs.columbia.edu; dkim=pass (signature was
 verified) header.d=armh.onmicrosoft.com;lists.cs.columbia.edu; dmarc=pass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT051.mail.protection.outlook.com (10.152.16.246) with
 Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 10:46:30 +0000
Received: ("Tessian outbound b610e7b4d771:v90");
 Mon, 19 Apr 2021 10:46:29 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ca7e584cd6a79d01
X-CR-MTA-TID: 64aa7808
Received: from f2336f9fcacb.2
 by 64aa7808-outbound-1.mta.getcheckrecipient.com id
 01F51A80-4D99-4079-B482-40EF7E3DC7FA.1; 
 Mon, 19 Apr 2021 10:46:20 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f2336f9fcacb.2
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
 Mon, 19 Apr 2021 10:46:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUbUtB83pTM4MxExNo5Go93lh5/uQcpZB7rXH6vfO/UEvBKPwExgc+7uGdn8IvKQ3Bt8ExNjNUdLrw8fZR3pkskcNcJ5NN/2yprzrej07vO7sTZd1EDvltoQkvkYIg5qxkO7eXxqgXKDxhMo51B8pZ1WvuUQoBHLPxM9aVpP6G0jnfLIc5x0txnboGrb4AHDdcc/N9340MEG58wxQXyKMq6CLyFqm0HoXXwrDc/8so058/Py6LVgmKPytwbRmhqHnTFMzpucjnKbTbTUlLjyPErYDq6d/gY0QzsVj8JD8DllLV6leHhXCCu3o2N+6NKVHl8xMRA9adbzwN9SQ7no3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9debTXzDLIdfioXqBmvIsaIcqA2u2D36//f4tWY7La4=;
 b=UYIESFWo+8r7wNzDE99XJrtKptsqlJFDJgjTAUnJSfLNz1MnvjRqq1+2jiT9UWByC3XcL51nFeEt0g+H/vVb4/n8PY6R08idO3JLwUNybjEaWQeu1d7MUFKome1bdwm/04PwB10ttFVQ3Ame6/zxfcuQFnLvrR9hKw8datOT28+sXtBJm0kmOFs24RF+y5bQOzgizelbzX3ED031xp3Dz6MtXWI7HgPgjrAUzzNZ08TP1c1GSNwi5LOzLm8Z5uGRBZAT6GAEeZx9ksS3SAL5MdqwKiGAFDnqoms9hteVhGfYa8JUh5pLnOoWV7divEjEEy+XM5ZJY/7QrIR7daJ9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com; 
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9debTXzDLIdfioXqBmvIsaIcqA2u2D36//f4tWY7La4=;
 b=jnv1xxa+w1v+8EhuBrPcGV8N2kzT5ilhoJaHniWyCYn+om6z2jVtrF0FO0FJI0Ly0vyHm4/uxDNbrHlW6Bd/Wfogdg1iCtFYnPOGkEnmSfsD5Nuwi0wFWRtTMpP9cPLGlQVP6ZBFw+uoND+zH7RfuNEgQxUT7Axy5e5MfMhkgEs=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from PR3PR08MB5868.eurprd08.prod.outlook.com (2603:10a6:102:81::6)
 by PAXPR08MB6493.eurprd08.prod.outlook.com (2603:10a6:102:15a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.20; Mon, 19 Apr
 2021 10:46:15 +0000
Received: from PR3PR08MB5868.eurprd08.prod.outlook.com
 ([fe80::ddf6:328a:3438:b062]) by PR3PR08MB5868.eurprd08.prod.outlook.com
 ([fe80::ddf6:328a:3438:b062%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 10:46:15 +0000
Subject: Re: [PATCH v2 3/4] KVM: stats: Add documentation for statistics data
 binary interface
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
References: <20210415151741.1607806-1-jingzhangos@google.com>
 <20210415151741.1607806-4-jingzhangos@google.com>
From: Yoan Picchi <yoan.picchi@arm.com>
Message-ID: <3d985605-a2ad-b25e-328c-c37cb4ef1794@arm.com>
Date: Mon, 19 Apr 2021 11:46:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210415151741.1607806-4-jingzhangos@google.com>
Content-Language: en-US
X-Originating-IP: [2a02:c7f:1ea5:1f00:f185:1f10:5739:c422]
X-ClientProxiedBy: LO2P265CA0011.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::23) To PR3PR08MB5868.eurprd08.prod.outlook.com
 (2603:10a6:102:81::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:c7f:1ea5:1f00:f185:1f10:5739:c422]
 (2a02:c7f:1ea5:1f00:f185:1f10:5739:c422) by
 LO2P265CA0011.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:62::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.21 via Frontend Transport; Mon, 19 Apr 2021 10:46:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1cb9d9-d301-4318-f410-08d903206406
X-MS-TrafficTypeDiagnostic: PAXPR08MB6493:|DB8PR08MB5369:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5369DB12E1774B98BE8BEBD6E4499@DB8PR08MB5369.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: WSdHmX85fWWzXYGF4lSirqa/81PZvA57OIlDtv0+7M6zbbLGDYADFtPpzfF/NLAid7AcKPjt7B7CEqQ30CXGaYc6IEqkhbPRkq5Dqq5TOlC+xe+5fEeToqizDkrWmjKXNB+T8rdghDc6H7i4qHR9t32EVBTmJH7/Vsw5lLjOIoOz52Z+6Iw1Nov3aet7NwVIHqVDNLSuOUvE//KDPkAf6XXxf4T2TrP5G9iC5qhxZFeQllxXVJiliyh9FgidDKNuQ2WaQTidKg2CDZoCosjHfmppdjXM1pdU84AW9N0cuRACMUxciS1rkABHoE9xUJsnuoNTL52wjWw9imnDbjAF7EHowyUBbCZRbGvKIP0cDBMjvQJp1FkkqKD5UvfF2CF+oBR97DKXXzO0XU92EP+j2ShBgRwDm5it93ayEO9U6/GzarnLIs1D1ySWIARam/KtSzkYZr4pq8PhrWgGi2wz43LAWKtU2HhjQ0q4u/BlF2zhRO4NuGmJ8DTpwnKfu0N9oaZX+GwwuG4SvqtdQsA6yUaOyzVXjnAphJ1htkV2cnd5HkJmb/1vlhBVvHgrJsIkniebMMnzmubJoHXg45izL9RrUhWQAwTxx/ZhAI/U5bi6/ekJ3ZLLkwuerhc2i42DbhM4ydWSGqUPNvMsPAdIShVmG0gcUjG86QK+DSZdbJFiEAF3PTykOrOkvQMPAdbQ4XEz0p7zRei7OP5HIiZqTA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255; CTRY:; LANG:en;
 SCL:1; SRV:; IPV:NLI; SFV:NSPM; H:PR3PR08MB5868.eurprd08.prod.outlook.com;
 PTR:; CAT:NONE;
 SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(8936002)(316002)(2906002)(8676002)(36756003)(2616005)(16526019)(31696002)(478600001)(5660300002)(7416002)(44832011)(83380400001)(6486002)(921005)(38100700002)(53546011)(86362001)(31686004)(110136005)(66556008)(66946007)(186003)(66476007)(43740500002)(45980500001);
 DIR:OUT; SFP:1101; 
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWxUWUxINmIzcXNqcWlSdXJnZTRUZVFJU1VNWlI3T3A2WGpNVkFLak5UNTl0?=
 =?utf-8?B?SUhld2MySGdIYjVlbytNeDFJVHRCWmpFYXpEVnhTRzV6T0xiTWFvSzk3UFcr?=
 =?utf-8?B?USs3SHpBV3o3M0tvZUdUcXFxM3NKVzlGMFhzU1dmSmxjZnJROWhSV2tXaHVu?=
 =?utf-8?B?dGVUSTRxQVl3T0JRMUtoc1p5ZVh6QlV2eUlGajJIMXBqdUFVYzlYUk4wSnFL?=
 =?utf-8?B?V3h3NjVMRXdUbzBDbG9Sem9zdWtwbkI4cjBBTkliaDExMkc2Q0ZWU2YzTWlJ?=
 =?utf-8?B?ekFLRGVraXc3OGVVUWpibkt0U1pvV0srcElsTWVjc2ovS2F2OUw4Wkg0OG9a?=
 =?utf-8?B?ZDQ2UGUvQ3o3QlFXSDh2SHJxQ3dVZ3ArU25uamlRQXZlYXEzK3NCZ1FTRkR2?=
 =?utf-8?B?akp1a29YaENqL3NqT1Nkcm03Uk0vOEpVQ2wrYi9YdThFUjFZOERYMXNhLzlv?=
 =?utf-8?B?a0VLVU11dkwzOGxlWGZva21hNWlxb3RRTjZ1ejh4ekJsYXZhNGtaRkhVMENG?=
 =?utf-8?B?KzR5aCtnb2UxRVRyR3cvSzl5U0VmdWl4elhibG5aQ0Q1Vm5XNFl6bkR4UnFR?=
 =?utf-8?B?WVdyVXFLbFpqd05vTkF1WFZRclI5bVNqci94b25sWnZYOWdKL3p2K3RtV1hy?=
 =?utf-8?B?TGZ2Q0tHSVJWMjVlSXMwZGorQTI4YXh4RVVlalBqcFI5bXFYSkppUFE3UWZu?=
 =?utf-8?B?RUxiZk5TRDBRSnpuOTBKc1pBeWpPUi9iTFdlbnJFek9WMFFyaDJFUS81Qms3?=
 =?utf-8?B?citLNjlsZ3hXMlYxWjY4eTk5dHh0ZkE4QTZCeURhNmJFaWNyQ2MycWxvTWtq?=
 =?utf-8?B?NnFSUTUzSmVndis1WHo3Tm9SeUxjL3I4VWtDTHJYRHQ5Rk9adUVaVzRrM082?=
 =?utf-8?B?c1A5MUk0dTJ0Y09pVkFMS1F3aEtITzExOG1JQU5RVWVhZEJKZ2hzaXd2eTRw?=
 =?utf-8?B?NzNZU2xqT1hsb1RNclphSHdFMkxVbUM4aUgrd3pya2puSUQ1Y0kzMCtyZGcz?=
 =?utf-8?B?VWVBYzh6NStBUkpFZFZGblZRWm5ETkU4K0Eva25jQXRPY0F4eGpHRmw5a3hV?=
 =?utf-8?B?NDVJNzBkeUNBaVZXNkdtSVFTcG5IaGFubDU0OFoxSFgzeW43MFVERXRTMy9K?=
 =?utf-8?B?UHhVMG1GbHdrRmtJSXpRSnZ4ME5lOC9GSTBab09HM29xSXJSSEZTajVzTDZp?=
 =?utf-8?B?YkNJdjZpODU1aU5HQTB4SmViWGw4SjF5Zmt2a3FpeU5WYzVlZUNqYVZtZlM2?=
 =?utf-8?B?dGs3L1B6dGVpZWVxcDE3bk9MbW9KWlJUOEJ2NFVraHFaUjJqWWVJTkNZeGtI?=
 =?utf-8?B?b1NjTjhlYVVjZ0tYTHB3bjVxWEw5c3g1RlFQVkFHNkduZ0dvYzZ4UTc4Q200?=
 =?utf-8?B?Q3dsSHlSKzFrdWdVS25UdjQyMytUR1NxTlorTXNuUUl4N01rNXZ4S21xWFo4?=
 =?utf-8?B?S0h4TUtTbFlvQXgzSlhSQm5rTWlrT0RmWnBFMS9oVHJ2RjE4RzhYNUNjanB3?=
 =?utf-8?B?c3dYanNHZ3d0MzV6bm9YRVIyOFJqYW9mQVllRVZiQUZXTnR5TWJwMzk5TURn?=
 =?utf-8?B?cnBlcDNpVmtrK0NDN3dLSThDY0lsMGppUU5EeHcvcXhVdXNiRERIelpLaFFK?=
 =?utf-8?B?d1RhL25ndGpFK0hQMFJ1SDlNWEZualRDelEwM1pIYXNveTJTU1VSUkRLUjlx?=
 =?utf-8?B?NkN3Ty9ZRXUwUGZGcXhSUjdRL1BEdHVNUldMLzFVZGhZamNvVS9JZGR5MFUw?=
 =?utf-8?B?TkhHYU5XUFJlRFg4alRpYjJFckxERzJob2Z5MmZsWDlWcTBsQWxXVmFZRkR1?=
 =?utf-8?B?OEF3aW4xQlZ2ZXMxVGNRVG9BRjhHb3EvOEl3REppWXZ5OEkzM0I5UHBpZTNn?=
 =?utf-8?Q?aBz7R/2Sp0YeY?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6493
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8d6894ef-1152-426c-c77e-08d903205ada
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IekY9TIr9lbb1tt64ziOk4UhXBxcb76Ax0ogXZiOlyWTyrCXnL2o8SqRDh9mRXEaeee0eNO9Ev5lnvFlP2e1KEY9oB7ZoJY+XBj9Td0eX+Uw5Ej6AE9cvKHISM5Qik0W0bhVX5sxmy1BGHfu0HOWFJMNm7B/QbnY9uh7AHtoo/S/Mvw0Ncb46Ey/ZNJ4VjSBglkwULoKqYoauTRPycaebpbnF/sY4uns05KF1QcxGkUKUPeboWV3aPSK8P6ZKQeyFDrlpLYi5Zq/GFXfiicJjJIZIRAn0ijZmg0yQdZeRp3JhduP2G5ht/68j4YbgyfPl5fVwmMMT1KWx1fFLEFCW26GOytfW4VL3YS/1UvSavcMYb0xJO8LJDCeP2WVYQtKU7M9nY/tqL1pjEIQTrsteeBfTW4qRnYpc181XxCEP10wynnbocSDkFPHeCJfuFXfMBOmywWebIDNPJy73pmpQjRLs3Bctc1JhG42sxoxuRRFZ1bRWRbWK/MNbSxYT/5yk1j9RdsdR4oSunT2AB7lc4HkHDN2d9gZ2mbEmU0O1G8iWGnrYsYwXghqvFwpQZ4tlRHd0PE1SDqw+O6zoqMSWDWqopnbHWBxPQHf4XVNjLgQZ2lMOKzX0L19V9MNo41W84nKLiEsjAx/PK618B/xPl6XgxQesbRvqvekq+S8EYbg5gMXUCf8epY3MBVAUUv/aW4zFvNLhqhDvmlaGfaxOg==
X-Forefront-Antispam-Report: CIP:63.35.35.123; CTRY:IE; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:64aa7808-outbound-1.mta.getcheckrecipient.com;
 PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com; CAT:NONE;
 SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(46966006)(36840700001)(70586007)(36756003)(44832011)(47076005)(5660300002)(921005)(36860700001)(8936002)(26005)(81166007)(336012)(356005)(478600001)(83380400001)(82310400003)(316002)(2616005)(53546011)(6486002)(110136005)(16526019)(31686004)(82740400003)(86362001)(186003)(8676002)(31696002)(70206006)(2906002)(43740500002);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 10:46:30.0890 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1cb9d9-d301-4318-f410-08d903206406
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d; Ip=[63.35.35.123];
 Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT051.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5369
X-Mailman-Approved-At: Mon, 19 Apr 2021 11:38:13 -0400
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hello Jing, and thanks for the patches. Just two small nitpicks.

On 15/04/2021 16:17, Jing Zhang wrote:
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>   Documentation/virt/kvm/api.rst | 169 +++++++++++++++++++++++++++++++++
>   1 file changed, 169 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2c4253718881..6474c31a4436 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4941,6 +4941,167 @@ see KVM_XEN_VCPU_SET_ATTR above.
>   The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
>   with the KVM_XEN_VCPU_GET_ATTR ioctl.
>
> +4.131 KVM_STATS_GETFD
> +---------------------
> +
> +:Capability: KVM_CAP_STATS_BINARY_FD
> +:Architectures: all
> +:Type: vm ioctl, vcpu ioctl
> +:Parameters: none
> +:Returns: statistics file descriptor on success, < 0 on error
> +
> +Errors:
> +
> +  ======     ======================================================
> +  ENOMEM     if the fd could not be created due to lack of memory
> +  EMFILE     if the number of opened files exceeds the limit
> +  ======     ======================================================
> +
> +The file descriptor can be used to read VM/vCPU statistics data in binary
> +format. The file data is organized into three blocks as below:
> ++-------------+
> +|   Header    |
> ++-------------+
> +| Descriptors |
> ++-------------+
> +| Stats Data  |
> ++-------------+
> +
> +The Header block is always at the start of the file. It is only needed to be
> +read one time after a system boot.
> +It is in the form of ``struct kvm_stats_header`` as below::
> +
> +     #define KVM_STATS_ID_MAXLEN                     64


Removing one tab would align the 64 with the defines below, though it
might be a tad close to the id field. I'm not sure which is best but
I'll still mention it.


> +     struct kvm_stats_header {
> +             char id[KVM_STATS_ID_MAXLEN];
> +             __u32 name_size;
> +             __u32 count;
> +             __u32 desc_offset;
> +             __u32 data_offset;
> +     };
> +
> +The ``id`` field is identification for the corresponding KVM statistics. For
> +KVM statistics, it is in the form of "kvm-{kvm pid}", like "kvm-12345". For
> +VCPU statistics, it is in the form of "kvm-{kvm pid}/vcpu-{vcpu id}", like
> +"kvm-12345/vcpu-12".
> +
> +The ``name_size`` field is the size (byte) of the statistics name string
> +(including trailing '\0') appended to the end of every statistics descriptor.
> +
> +The ``count`` field is the number of statistics.
> +
> +The ``desc_offset`` field is the offset of the Descriptors block from the start
> +of the file indicated by the file descriptor.
> +
> +The ``data_offset`` field is the offset of the Stats Data block from the start
> +of the file indicated by the file descriptor.
> +
> +The Descriptors block is only needed to be read once after a system boot. It is
> +an array of ``struct kvm_stats_desc`` as below::
> +
> +     #define KVM_STATS_TYPE_SHIFT            0
> +     #define KVM_STATS_TYPE_MASK             (0xF << KVM_STATS_TYPE_SHIFT)
> +     #define KVM_STATS_TYPE_CUMULATIVE       (0x0 << KVM_STATS_TYPE_SHIFT)
> +     #define KVM_STATS_TYPE_INSTANT          (0x1 << KVM_STATS_TYPE_SHIFT)
> +     #define KVM_STATS_TYPE_MAX              KVM_STATS_TYPE_INSTANT
> +
> +     #define KVM_STATS_UNIT_SHIFT            4
> +     #define KVM_STATS_UNIT_MASK             (0xF << KVM_STATS_UNIT_SHIFT)
> +     #define KVM_STATS_UNIT_NONE             (0x0 << KVM_STATS_UNIT_SHIFT)
> +     #define KVM_STATS_UNIT_BYTES            (0x1 << KVM_STATS_UNIT_SHIFT)
> +     #define KVM_STATS_UNIT_SECONDS          (0x2 << KVM_STATS_UNIT_SHIFT)
> +     #define KVM_STATS_UNIT_CYCLES           (0x3 << KVM_STATS_UNIT_SHIFT)
> +     #define KVM_STATS_UNIT_MAX              KVM_STATS_UNIT_CYCLES
> +
> +     #define KVM_STATS_SCALE_SHIFT           8
> +     #define KVM_STATS_SCALE_MASK            (0xF << KVM_STATS_SCALE_SHIFT)
> +     #define KVM_STATS_SCALE_POW10           (0x0 << KVM_STATS_SCALE_SHIFT)
> +     #define KVM_STATS_SCALE_POW2            (0x1 << KVM_STATS_SCALE_SHIFT)
> +     #define KVM_STATS_SCALE_MAX             KVM_STATS_SCALE_POW2
> +     struct kvm_stats_desc {
> +             __u32 flags;
> +             __s16 exponent;
> +             __u16 size;
> +             __u32 unused1;
> +             __u32 unused2;
> +             __u8 name[0];
> +     };


Maybe add a new line between the define and the struct ? And do that as
well in the code ?


> +
> +The ``flags`` field contains the type and unit of the statistics data described
> +by this descriptor. The following flags are supported:
> +  * ``KVM_STATS_TYPE_CUMULATIVE``
> +    The statistics data is cumulative. The value of data can only be increased.
> +    Most of the counters used in KVM are of this type.
> +    The corresponding ``count`` filed for this type is always 1.
> +  * ``KVM_STATS_TYPE_INSTANT``
> +    The statistics data is instantaneous. Its value can be increased or
> +    decreased. This type is usually used as a measurement of some resources,
> +    like the number of dirty pages, the number of large pages, etc.
> +    The corresponding ``count`` field for this type is always 1.
> +  * ``KVM_STATS_UNIT_NONE``
> +    There is no unit for the value of statistics data. This usually means that
> +    the value is a simple counter of an event.
> +  * ``KVM_STATS_UNIT_BYTES``
> +    It indicates that the statistics data is used to measure memory size, in the
> +    unit of Byte, KiByte, MiByte, GiByte, etc. The unit of the data is
> +    determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_SCALE_POW2`` flag is valid in this case. The unit of the data is
> +    determined by ``pow(2, exponent)``. For example, if value is 10,
> +    ``exponent`` is 20, which means the unit of statistics data is MiByte, we
> +    can get the statistics data in the unit of Byte by
> +    ``value * pow(2, exponent) = 10 * pow(2, 20) = 10 MiByte`` which is
> +    10 * 1024 * 1024 Bytes.
> +  * ``KVM_STATS_UNIT_SECONDS``
> +    It indicates that the statistics data is used to measure time/latency, in
> +    the unit of nanosecond, microsecond, millisecond and second. The unit of the
> +    data is determined by the ``exponent`` field in the descriptor. The
> +    ``KVM_STATS_SCALE_POW10`` flag is valid in this case. The unit of the data
> +    is determined by ``pow(10, exponent)``. For example, if value is 2000000,
> +    ``exponent`` is -6, which means the unit of statistics data is microsecond,
> +    we can get the statistics data in the unit of second by
> +    ``value * pow(10, exponent) = 2000000 * pow(10, -6) = 2 seconds``.
> +  * ``KVM_STATS_UNIT_CYCLES``
> +    It indicates that the statistics data is used to measure CPU clock cycles.
> +    The ``KVM_STATS_SCALE_POW10`` flag is valid in this case. For example, if
> +    value is 200, ``exponent`` is 4, we can get the number of CPU clock cycles
> +    by ``value * pow(10, exponent) = 200 * pow(10, 4) = 2000000``.
> +
> +The ``exponent`` field is the scale of corresponding statistics data. It has two
> +values as follows:
> +  * ``KVM_STATS_SCALE_POW10``
> +    The scale is based on power of 10. It is used for measurement of time and
> +    CPU clock cycles.
> +  * ``KVM_STATS_SCALE_POW2``
> +    The scale is based on power of 2. It is used for measurement of memory size.
> +
> +The ``size`` field is the number of values of this statistics data. It is in the
> +unit of ``unsigned long`` for VCPU or ``__u64`` for VM.
> +
> +The ``unused1`` and ``unused2`` fields are reserved for future
> +support for other types of statistics data, like log/linear histogram.
> +
> +The ``name`` field points to the name string of the statistics data. The name
> +string starts at the end of ``struct kvm_stats_desc``.
> +The maximum length (including trailing '\0') is indicated by ``name_size``
> +in ``struct kvm_stats_header``.
> +
> +The Stats Data block contains an array of data values of type ``struct
> +kvm_vm_stats_data`` or ``struct kvm_vcpu_stats_data``. It would be read by
> +user space periodically to pull statistics data.
> +The order of data value in Stats Data block is the same as the order of
> +descriptors in Descriptors block.
> +  * Statistics data for VM::
> +
> +     struct kvm_vm_stats_data {
> +             unsigned long value[0];
> +     };
> +
> +  * Statistics data for VCPU::
> +
> +     struct kvm_vcpu_stats_data {
> +             __u64 value[0];
> +     };
> +
>   5. The kvm_run structure
>   ========================
>
> @@ -6740,3 +6901,11 @@ vcpu_info is set.
>   The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
>   features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
>   supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
> +
> +8.31 KVM_CAP_STATS_BINARY_FD
> +----------------------------
> +
> +:Architectures: all
> +
> +This capability indicates the feature that user space can create get a file
> +descriptor for every VM and VCPU to read statistics data in binary format.
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
