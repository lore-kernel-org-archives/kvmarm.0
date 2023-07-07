Received: from m1365.mail.163.com (m1365.mail.163.com [220.181.13.65])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771E563C9
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 07:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=6qCSUZtvzTF6ZzhEbPOw7Uqd1CWuzuRLgtKow35DTbQ=; b=F
	heumYyBkee9YxYm7WG0DADCtBSvbYgBZ1yXJXHFClmP/cTEAxSBWqg0q4bmf+ZsW
	yMZEnKo7zVNipRsFD+d/4caTHTv7oA5vhL6u4pM/WzdsynEnl62kAqQScLTzPFFr
	wOwx47AQLxp7PjoQHGkk+fhWdpTNx3YlvZFNMIYdk0=
Received: from yshxxsjt715$163.com ( [113.128.89.9] ) by
 ajax-webmail-wmsvr65 (Coremail) ; Fri, 7 Jul 2023 15:10:39 +0800 (CST)
X-Originating-IP: [113.128.89.9]
Date: Fri, 7 Jul 2023 15:10:39 +0800 (CST)
From: Norman <yshxxsjt715@163.com>
To: kvmarm@lists.linux.dev
Subject: Is it a good idea to allow setting invariant_sys_regs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
X-NTES-SC: AL_QuyTCvuavEAo7yGYYekXn0oTgug4Ucq0vfkm2IdSOZk0lirr5jAtQ3N8N0DP7NmQNDyjvBSpeypE9/ZceJlIVKewndoqPJ3mLvbfqbvX72OK
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <18dda0a5.212c.1892f304206.Coremail.yshxxsjt715@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:QcGowAAHsPlvuqdkXnAYAA--.21615W
X-CM-SenderInfo: h1vk555vmwliqv6rljoofrz/1tbiIA6hL10TNj4ZywABs1
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhlbGxvIGNvbW11bml0eSBleHBlcnRzLAoKCsKgIMKgSSBhbSB3b3JraW5nIG9uIHJlc2VhcmNo
IHRvIGFsbG93IGxpdmUgbWlncmF0aW9uIG9mIEFSTTY0IHZpcnR1YWwgbWFjaGluZXMgYmV0d2Vl
biBob3N0cwp3aXRoIGRpZmZlcmVudCB2ZW5kb3JzLiBUaGUgY3VycmVudCA2LjIgUUVNVSBkb2Vz
IG5vdCB3b3JrIG91dCBvZiB0aGUgYm94LiBJIGRpZCBzb21lIGRlYnVnZ2luZ8KgYW5kIGFtIGJl
bGlldmluZyBpdCBpcyB0aGUgaW52YXJpYW50IHN5cyByZWdzIGJsb2NraW5nIGxpdmUgbWlncmF0
aW9uLiBPYnZpb3VzbHksIGhvc3RzIGZyb20gZGlmZmVyZW50IHZlbmRvcnMgaGF2aW5nIGRpZmZl
cmVudCBtaWRyIHJlZ2lzdGVycyBmaWxsZWQuCgoKwqAgwqBTbyBteSBxdWVzdGlvbiBpcyBpcyBp
dCBhIGdvb2QgaWRlYSB0byBhbGxvdyBzZXR0aW5nIGludmFyaWFudF9zeXNfcmVncz8gVGhhbmsg
eW91IHZlcnkgbXVjaCBmb3IgdGhlIGdlbmVyb3VzIGhlbHAuCgoKCg==
