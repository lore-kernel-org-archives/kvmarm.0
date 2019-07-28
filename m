Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39672C7618B
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 10:49:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B600720C01
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 10:49:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B600720C01
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14DE54A55A;
	Mon, 29 Jul 2019 06:49:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tUs5aIFZMKHi; Mon, 29 Jul 2019 06:49:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CC34A535;
	Mon, 29 Jul 2019 06:49:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E469C4A53F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 18:53:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KIOPE+mhcAk2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Jul 2019 18:53:18 -0400 (EDT)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C006E4A50F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 18:53:18 -0400 (EDT)
Received: by mail-wr1-f66.google.com with SMTP id f9so59720298wre.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 15:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=ftGcDLnR4imQmQ+UkOat+KWbwwjELLyC+CYKk4KZ2MI=;
 b=aWUXX4A87zSyJAPkrkmlcN5YKeDQRCRj5+A0LgARyrU+lJE3uCx3sxZdLpIF2Gnbrz
 YaMPyAdiGriVH+wxL28gokPj+aOZnHmgXmEAzidmnTVWVhbPC6DsU45MOl6HdJgUx1ln
 7FXi/NHzqa2y22GaRSKb3EkXPj0Qv1BEcXPyZCEXWewQDFPPbTNrF1PSlymUO96ZQGQn
 VVMkpviUa9I6LU8srINzeeKFoH6xq9CMtDORCNsch2l0LpCzffg8vie/wLCYsep2m+uW
 CDiciFRVPPJfjCBgBuFk9J+B+CpAfLWIWDbphSLnOLWw4y7K8awU8WMdE2cYneRv6qbE
 AJ9g==
X-Gm-Message-State: APjAAAUqMYSp6KEsVbLTcaS+loC3baBnpUXoN4teVdpyNf9bFYeSM7AL
 Mnh4stZKl4p6kbfV3N5ynrs5jg==
X-Google-Smtp-Source: APXvYqzXz/uRYLBkINGQsD6hev7BbnvXZn0rdIH9tudJoRoTw/rjgcK0VY1Im/N583+KNY1tUym6uQ==
X-Received: by 2002:a5d:4212:: with SMTP id
 n18mr112558387wrq.261.1564354397866; 
 Sun, 28 Jul 2019 15:53:17 -0700 (PDT)
Received: from mcroce-redhat.homenet.telecomitalia.it
 (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
 by smtp.gmail.com with ESMTPSA id q193sm45278109wme.8.2019.07.28.15.53.16
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Sun, 28 Jul 2019 15:53:17 -0700 (PDT)
From: Matteo Croce <mcroce@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: mark expected switch fall-through
Date: Mon, 29 Jul 2019 00:53:11 +0200
Message-Id: <20190728225311.5414-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 29 Jul 2019 06:49:21 -0400
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

TWFyayBzd2l0Y2ggY2FzZXMgd2hlcmUgd2UgYXJlIGV4cGVjdGluZyB0byBmYWxsIHRocm91Z2gs
CmZpeGVzIHRoZSBmb2xsb3dpbmcgd2FybmluZzoKCkluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2VtdWxhdGUuaDoxOSwKICAgICAgICAgICAgICAgICBm
cm9tIGFyY2gvYXJtNjQva3ZtL3JlZ21hcC5jOjEzOgphcmNoL2FybTY0L2t2bS9yZWdtYXAuYzog
SW4gZnVuY3Rpb24g4oCYdmNwdV93cml0ZV9zcHNyMzLigJk6Ci4vYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1faHlwLmg6MzE6Mzogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwgdGhy
b3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgIGFzbSB2b2xhdGlsZShBTFRFUk5BVElW
RShfX21zcl9zKHIjI252aCwgIiV4MCIpLCBcCiAgIF5+fgouL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2h5cC5oOjQ2OjMxOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYd3JpdGVf
c3lzcmVnX2VseOKAmQogI2RlZmluZSB3cml0ZV9zeXNyZWdfZWwxKHYscikgd3JpdGVfc3lzcmVn
X2VseCh2LCByLCBfRUwxLCBfRUwxMikKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+
fn5+fn5+fn5+fn5+fn4KYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTgwOjM6IG5vdGU6IGluIGV4
cGFuc2lvbiBvZiBtYWNybyDigJh3cml0ZV9zeXNyZWdfZWwx4oCZCiAgIHdyaXRlX3N5c3JlZ19l
bDEodiwgU1lTX1NQU1IpOwogICBefn5+fn5+fn5+fn5+fn5+CmFyY2gvYXJtNjQva3ZtL3JlZ21h
cC5jOjE4MToyOiBub3RlOiBoZXJlCiAgY2FzZSBLVk1fU1BTUl9BQlQ6CiAgXn5+fgpJbiBmaWxl
IGluY2x1ZGVkIGZyb20gLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2NwdXR5cGUuaDoxMzIsCiAg
ICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY2FjaGUuaDo4LAog
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L2NhY2hlLmg6NiwKICAgICAgICAg
ICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9wcmludGsuaDo5LAogICAgICAgICAgICAgICAg
IGZyb20gLi9pbmNsdWRlL2xpbnV4L2tlcm5lbC5oOjE1LAogICAgICAgICAgICAgICAgIGZyb20g
Li9pbmNsdWRlL2FzbS1nZW5lcmljL2J1Zy5oOjE4LAogICAgICAgICAgICAgICAgIGZyb20gLi9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2J1Zy5oOjI2LAogICAgICAgICAgICAgICAgIGZyb20gLi9p
bmNsdWRlL2xpbnV4L2J1Zy5oOjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGlu
dXgvbW1kZWJ1Zy5oOjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW0u
aDo5LAogICAgICAgICAgICAgICAgIGZyb20gYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTE6Ci4v
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaDo4Mzc6Mjogd2FybmluZzogdGhpcyBzdGF0
ZW1lbnQgbWF5IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgYXNtIHZv
bGF0aWxlKCJtc3IgIiBfX3N0cmluZ2lmeShyKSAiLCAleDAiICBcCiAgXn5+CmFyY2gvYXJtNjQv
a3ZtL3JlZ21hcC5jOjE4MjozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYd3JpdGVf
c3lzcmVn4oCZCiAgIHdyaXRlX3N5c3JlZyh2LCBzcHNyX2FidCk7CiAgIF5+fn5+fn5+fn5+fgph
cmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODM6Mjogbm90ZTogaGVyZQogIGNhc2UgS1ZNX1NQU1Jf
VU5EOgogIF5+fn4KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9jcHV0eXBlLmg6MTMyLAogICAgICAgICAgICAgICAgIGZyb20gLi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2NhY2hlLmg6OCwKICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9j
YWNoZS5oOjYsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvcHJpbnRrLmg6
OSwKICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9rZXJuZWwuaDoxNSwKICAg
ICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9hc20tZ2VuZXJpYy9idWcuaDoxOCwKICAgICAg
ICAgICAgICAgICBmcm9tIC4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9idWcuaDoyNiwKICAgICAg
ICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9idWcuaDo1LAogICAgICAgICAgICAgICAg
IGZyb20gLi9pbmNsdWRlL2xpbnV4L21tZGVidWcuaDo1LAogICAgICAgICAgICAgICAgIGZyb20g
Li9pbmNsdWRlL2xpbnV4L21tLmg6OSwKICAgICAgICAgICAgICAgICBmcm9tIGFyY2gvYXJtNjQv
a3ZtL3JlZ21hcC5jOjExOgouL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3lzcmVnLmg6ODM3OjI6
IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFs
bHRocm91Z2g9XQogIGFzbSB2b2xhdGlsZSgibXNyICIgX19zdHJpbmdpZnkocikgIiwgJXgwIiAg
XAogIF5+fgphcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODQ6Mzogbm90ZTogaW4gZXhwYW5zaW9u
IG9mIG1hY3JvIOKAmHdyaXRlX3N5c3JlZ+KAmQogICB3cml0ZV9zeXNyZWcodiwgc3Bzcl91bmQp
OwogICBefn5+fn5+fn5+fn4KYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTg1OjI6IG5vdGU6IGhl
cmUKICBjYXNlIEtWTV9TUFNSX0lSUToKICBefn5+CkluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2Fy
Y2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oOjEzMiwKICAgICAgICAgICAgICAgICBmcm9t
IC4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9jYWNoZS5oOjgsCiAgICAgICAgICAgICAgICAgZnJv
bSAuL2luY2x1ZGUvbGludXgvY2FjaGUuaDo2LAogICAgICAgICAgICAgICAgIGZyb20gLi9pbmNs
dWRlL2xpbnV4L3ByaW50ay5oOjksCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGlu
dXgva2VybmVsLmg6MTUsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvYXNtLWdlbmVy
aWMvYnVnLmg6MTgsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vYnVnLmg6MjYsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvYnVnLmg6
NSwKICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9tbWRlYnVnLmg6NSwKICAg
ICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9tbS5oOjksCiAgICAgICAgICAgICAg
ICAgZnJvbSBhcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxMToKLi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL3N5c3JlZy5oOjgzNzoyOiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFsbCB0aHJv
dWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KICBhc20gdm9sYXRpbGUoIm1zciAiIF9fc3Ry
aW5naWZ5KHIpICIsICV4MCIgIFwKICBefn4KYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTg2OjM6
IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJh3cml0ZV9zeXNyZWfigJkKICAgd3JpdGVf
c3lzcmVnKHYsIHNwc3JfaXJxKTsKICAgXn5+fn5+fn5+fn5+CmFyY2gvYXJtNjQva3ZtL3JlZ21h
cC5jOjE4NzoyOiBub3RlOiBoZXJlCiAgY2FzZSBLVk1fU1BTUl9GSVE6CiAgXn5+fgoKU2lnbmVk
LW9mZi1ieTogTWF0dGVvIENyb2NlIDxtY3JvY2VAcmVkaGF0LmNvbT4KLS0tCiBhcmNoL2FybTY0
L2t2bS9yZWdtYXAuYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQoK
ZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3JlZ21hcC5jIGIvYXJjaC9hcm02NC9rdm0vcmVn
bWFwLmMKaW5kZXggMGQ2MGU0ZjBhZjY2Li5iMzc2YjJmZGJmNTEgMTAwNjQ0Ci0tLSBhL2FyY2gv
YXJtNjQva3ZtL3JlZ21hcC5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3JlZ21hcC5jCkBAIC0xNzgs
MTIgKzE3OCwxNiBAQCB2b2lkIHZjcHVfd3JpdGVfc3BzcjMyKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgdW5zaWduZWQgbG9uZyB2KQogCXN3aXRjaCAoc3Bzcl9pZHgpIHsKIAljYXNlIEtWTV9TUFNS
X1NWQzoKIAkJd3JpdGVfc3lzcmVnX2VsMSh2LCBTWVNfU1BTUik7CisJCS8qIGZhbGx0aHJvdWdo
ICovCiAJY2FzZSBLVk1fU1BTUl9BQlQ6CiAJCXdyaXRlX3N5c3JlZyh2LCBzcHNyX2FidCk7CisJ
CS8qIGZhbGx0aHJvdWdoICovCiAJY2FzZSBLVk1fU1BTUl9VTkQ6CiAJCXdyaXRlX3N5c3JlZyh2
LCBzcHNyX3VuZCk7CisJCS8qIGZhbGx0aHJvdWdoICovCiAJY2FzZSBLVk1fU1BTUl9JUlE6CiAJ
CXdyaXRlX3N5c3JlZyh2LCBzcHNyX2lycSk7CisJCS8qIGZhbGx0aHJvdWdoICovCiAJY2FzZSBL
Vk1fU1BTUl9GSVE6CiAJCXdyaXRlX3N5c3JlZyh2LCBzcHNyX2ZpcSk7CiAJfQotLSAKMi4yMS4w
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
