Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0218428F7;
	Fri, 27 Jan 2023 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=33gJpoAbHMpJgShtK36NvshIaiJwXLMHJRWF/7XkPzEN5LMpvoAg51lA8KbjuVpPTMWBz6IcoUy7kJOABQ7HO0gjf+5X/J06znkx5cJIqi7gQz4PkGQu26VriCeSMlAv/dutdE1XVtHrWBNIOEriEVbnmEYk7ASKKJp/mBxjhgw=
Received: from DUZPR01CA0096.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::19) by AS4PR08MB8141.eurprd08.prod.outlook.com
 (2603:10a6:20b:58c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 11:44:04 +0000
Received: from DBAEUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:4bb:cafe::10) by DUZPR01CA0096.outlook.office365.com
 (2603:10a6:10:4bb::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.34 via Frontend
 Transport; Fri, 27 Jan 2023 11:44:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DBAEUR03FT047.mail.protection.outlook.com (100.127.143.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Fri, 27 Jan 2023 11:44:04 +0000
Received: ("Tessian outbound b1d3ffe56e73:v132"); Fri, 27 Jan 2023 11:44:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 79fec1a3b4157ab0
X-CR-MTA-TID: 64aa7808
Received: from 9134af7da11f.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id E8CDC639-88BD-455C-B67E-8AC8E24ADBE9.1;
	Fri, 27 Jan 2023 11:41:29 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 9134af7da11f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Jan 2023 11:41:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nmq85NsRTvJ2QTNZU5yQQMc+1XrRAE/uDbfZf4t7WFttH5OiOofMK5XDqtSn0SA/HxnBq4ZZREi8wIrOyABIAaRWNBVK5tSG+uZWfIWfhbCTDFfX/Zg2+DlqetX1BgkaQn50CIbNy5LzXf41wl7lRWHZ5Fyrz59Y+7lrAOgJwp5cxOeZRN1Lxka8MQHh7fZCB8qhEDeMh/qCNMbPow/9WZm5AKL35DkX/eJet3TNNQppLk8pt9dFSt5C84TddfjPPMGXs86T4+wvPqjQM+QDAMx0xAlHYVEfDK7aI1XXBFXc4SsTG9xipNeAh36HOrS31rpKdCkGOvBW+N5hV/Q8tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=S3FG+yu+FRUfUQnX2D3d8jTBGn7N2o5tt/lzRllOZSgzb5UspJSj28lKSTJUFkdZC4G/mLUMbjmPWgJyda28pe5T1wzS1xqmsvV4drWFW+AkhxvUX4Z6EV4YrOdkuDJgROXoyOLl9+kg0rOuV5joUmbnZhm7YPeEf8DbGUHvXJ6J6fNoKSMXL5Z8vNqX0aDDxx7ureDgXzYVLt3hKbmN/8yiqT6YnH2HiyQqp0s/YmcYr5MZseyQ6ULeiVwmOEg2/CSV7z1lWkRGmtJwOs/mdVIT/iVOJXL87EKKudIa4ZpCT7K/hTzFU110wvGq0v5/NYyJfN6UzXMpIt4bhg3adQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAthAYOVywOx8lXe0h46x7ZB6wNi2URhTTiXJIcBscU=;
 b=33gJpoAbHMpJgShtK36NvshIaiJwXLMHJRWF/7XkPzEN5LMpvoAg51lA8KbjuVpPTMWBz6IcoUy7kJOABQ7HO0gjf+5X/J06znkx5cJIqi7gQz4PkGQu26VriCeSMlAv/dutdE1XVtHrWBNIOEriEVbnmEYk7ASKKJp/mBxjhgw=
Received: from AS9PR06CA0224.eurprd06.prod.outlook.com (2603:10a6:20b:45e::21)
 by AS8PR08MB10149.eurprd08.prod.outlook.com (2603:10a6:20b:63f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 11:41:27 +0000
Received: from AM7EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45e:cafe::17) by AS9PR06CA0224.outlook.office365.com
 (2603:10a6:20b:45e::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT049.mail.protection.outlook.com (100.127.140.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.23 via Frontend Transport; Fri, 27 Jan 2023 11:41:27 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:22 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16; Fri, 27 Jan
 2023 11:41:21 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Fri, 27 Jan 2023 11:41:16 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>
CC: <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joey Gouly
	<Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini
	<pbonzini@redhat.com>, Quentin Perret <qperret@google.com>, Steven Price
	<steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Thomas
 Huth" <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC kvm-unit-tests 01/27] lib/string: include stddef.h for size_t
Date: Fri, 27 Jan 2023 11:40:42 +0000
Message-ID: <20230127114108.10025-2-joey.gouly@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230127114108.10025-1-joey.gouly@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic:
	AM7EUR03FT049:EE_|AS8PR08MB10149:EE_|DBAEUR03FT047:EE_|AS4PR08MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: a6072776-e262-4fda-b66c-08db005bcaa0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 onWF71zoO6duUEy+orjL4HaxS7SZPO7QtYxVx46ihrlGO+YyVonwfIlTIu00ZAPHMs7YkA3E6vU9GnqqdU27eMrSPYu/x1wCRnudyHy5gM/gZ8W7/GgTP5530FbyNkMiccVtwRyU2fvbqEiy9RK1HPX2oYrwhFWhi005jQEdRWSrf3HGKCulEBesNQpa1HUJ7IX5eWG7Gjnj8oRYS1cVcnMrKM31Iy7uzvnvw0iQ0v9TF90z8j0TzhNxvG1sZy363v1rvCg/wb0CjxzQWQhy4k2/B92exKQP8b+gt6aoXdM7pppTWhPHkg4RFXqpeB//gffmF3kcfMNWSFOuJYgMBYiMBGgj7vWdlZOZCsY102gVLqjuSvqkOhWjhiP8fFBdx9vWelXzjr75mW5MFs7PjZeSed0SY3ZfC1ItTa5Hfgexj5m7uCnVXw6HS0MKqzbYGYyfhQe9bVZH3ljQhwkIGpHflS4rq4KlXj+c+GN2Hltz0Ji1LsUkffHEwQr77tNThmnTwWZ0Q6tWJxJWkgiFx9yv0AKf7hlmfY6pcfUhaAK1HW9Ol18oebkFwl8x9HV1Fob94Zuz8Z6ITPJozmg7vhKbT832BIzIpqfqkq9cDh2mf3LI2Rz69J6BJRO7WzFae424vUO7jvYEwraiwCLr80DtcXANe0WX6ud3b5uvawutaZjZy9kr+NJe00cAjQhlePoGZ2ibeu/4qkgzuzuHutcwKkoXLNePSB4mKNvd6xiRUw7Mk9Micf72EgyKR/T7
X-Forefront-Antispam-Report-Untrusted:
 CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(40470700004)(46966006)(36840700001)(82740400003)(36756003)(40460700003)(4744005)(82310400005)(356005)(316002)(5660300002)(26005)(7696005)(186003)(8936002)(47076005)(36860700001)(4326008)(40480700001)(2906002)(7416002)(70206006)(70586007)(6666004)(478600001)(81166007)(426003)(336012)(8676002)(44832011)(41300700001)(1076003)(54906003)(2616005)(110136005)(86362001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB10149
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DBAEUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f5b9ad6e-8f74-4b5f-466a-08db005b6cdd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QjyufhJ3T2V0BTpjebv0GV+7x4xEhrsmmZ97aWc4UDzt5mgeeR+g/ujrWo+FU+C7TikQmAnqEPI3JAg8pAE3rjHOLoAe7+5laMtSL/liKGFbX0a8cyeB6EGOtF4GMDDLDl0bY/pQzgR1edm+uBCnABZsJ9f+X0QLr/5jmuNWaUHH1/otynypayHmkvWEspSIx7cfNc+DnSwKNwNZK8Aj05urfeCpKtT0oMuXJojOtw4aus7QWGcolAfkyPJf5pToH1HRjrkwuliYqce/xYkVlEuxlZSAkYGAxPQ+4LimsGzEtHdSjRc3Y+Izst9POnXdyFkzOJGSl+gJkyx9na5bwbbo2trV0Zmm81R8SWjRDqOTcIREAbQ4oyPAVZq8+HfXrQc5q0eYSBQ90ruud0nRl0WLSk5M92Il+3l4Z/WTzWf6J4rjaXXHFhLTer5OYLl1wJK4kQp9EMSDutENlpEVQHpxcNCwEyGIq0otP1mixeAeDoQkIMilwV/W6LOkwRtiLU5OK08vhnECD1B58cUteycy7YHbbXvq7INCKPsLB2etw2aqyYB1KuMR8QSEqVqjOU+iRKHEnug9krd877Ig+WjXXUPwlrZN1hVPHA73vjWAGtVuHZ322tI+uaZD6gyxumtpTEb52vGBofqlVZGt5dX8oUmIt4LgrTEzHf6hFwRwiEKT7I6DvGUTDSkTCFeY3mqYdbp4vF4AmfHgZIEvhzIjQ+0mvZxECE4VEKR2Sxk=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(44832011)(54906003)(70206006)(70586007)(4326008)(450100002)(8936002)(41300700001)(110136005)(316002)(8676002)(82310400005)(36756003)(36860700001)(7696005)(478600001)(1076003)(4744005)(336012)(2616005)(6666004)(47076005)(107886003)(186003)(5660300002)(26005)(40460700003)(81166007)(426003)(40480700001)(86362001)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 11:44:04.4454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6072776-e262-4fda-b66c-08db005bcaa0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DBAEUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8141

Don't implicitly rely on this header being included.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 lib/string.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/string.h b/lib/string.h
index b07763ea..758dca8a 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -7,6 +7,8 @@
 #ifndef _STRING_H_
 #define _STRING_H_
 
+#include <stddef.h>  /* For size_t */
+
 extern size_t strlen(const char *buf);
 extern size_t strnlen(const char *buf, size_t maxlen);
 extern char *strcat(char *dest, const char *src);
-- 
2.17.1

