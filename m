From: harry <tiancaixiaoyu90@126.com>
Subject: KVM/ARM: How to read the value of some physical address in HYP mode
Date: Mon, 17 Aug 2015 09:59:20 +0800 (CST)
Message-ID: <259c0e14.2f0f.14f3961e161.Coremail.tiancaixiaoyu90@126.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3149291469192069755=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ECD05AD8E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2015 21:46:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pp57grqDAFYG for <kvmarm@lists.cs.columbia.edu>;
 Sun, 16 Aug 2015 21:46:06 -0400 (EDT)
Received: from m15-37.126.com (m15-37.126.com [220.181.15.37])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E79EC5AD8D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 16 Aug 2015 21:46:05 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============3149291469192069755==
Content-Type: multipart/alternative;
	boundary="----=_Part_46926_1904805325.1439776760161"

------=_Part_46926_1904805325.1439776760161
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SGksIAoKCkkgd2FudCB0byByZWFkIHRoZSB2YWx1ZSBvZiBzb21lIHBoeXNpY2FsIGFkZHJlc3Mg
aW4gSFlQIG1vZGUuIEJ1dCBtYXliZSB0aGVyZSBpc24ndCBhbnkgaW50ZXJmYWNlIHRvIGFjaGll
dmUgdGhpcy4gSSBob3BlIHRvIGdldCBzb21lIGlkZWFzIHRvIGFjaGlldmUgdGhpcy4KCgpBbmQg
bm93IEkgaGF2ZSBhIHNpbXBsZSBpZGVhLCBidXQgSSBkb24ndCBrbm93IGlmIGl0IGlzIHBvc3Np
YmxlLiBXaGVuIHRoZSBIWVAgbW9kZSBpcyBpbml0LCB3ZSBjcmVhdGUgYSBtYXBwaW5nIGZyb20g
b25lIHNwZWNpYWwgdmlydHVhbCBhZGRyZXNzIHRvIHNvbWUgcGh5c2ljYWwgYWRkcmVzcy4gQW5k
IG1hcCB0aGUgdmEgdG8gSFlQIG1vZGUuIFdoZW4gd2Ugd2FudCB0byByZWFkIHRoZSB2YWx1ZSBv
ZiBzb21lIFBBLCB3ZSBtb2RpZnkgdGhlIHBhZ2UgdGFibGUgdG8gbGV0IHRoZSBzcGVjaWFsIFZB
IG1hcCB0byB0aGUgUEEsIHRoZW4gd2UgcmVhZCB0aGUgc3BlY2lhbCBWQSBhbmQgZ2V0IHRoZSB2
YWx1ZSBvZiB0aGUgUEEuIEJlY2F1c2UgSSBvbmx5IHN0YXJ0IHRvIHJlc2VhcmNoIG9uIHRoZSBL
Vk0sIHNvIEkgYW0gbm90IHN1cmUgaWYgdGhpcyBjYW4gd29yay4gSSBob3BlIHRvIGdldCBoZWxw
IHRvIGFjaGlldmUgdGhpcy4KCgpUaGFua3MgYW5kIHJlZ2FyZHMsCkhhcnJ5
------=_Part_46926_1904805325.1439776760161
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS43O2NvbG9yOiMwMDAwMDA7Zm9udC1zaXplOjE0cHg7
Zm9udC1mYW1pbHk6QXJpYWwiPjxkaXY+SGksJm5ic3A7PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRp
dj5JIHdhbnQgdG8gcmVhZCB0aGUgdmFsdWUgb2Ygc29tZSBwaHlzaWNhbCBhZGRyZXNzIGluIEhZ
UCBtb2RlLiBCdXQgbWF5YmUgdGhlcmUgaXNuJ3QgYW55IGludGVyZmFjZSB0byBhY2hpZXZlIHRo
aXMuIEkgaG9wZSB0byBnZXQgc29tZSBpZGVhcyB0byBhY2hpZXZlIHRoaXMuPC9kaXY+PGRpdj48
YnI+PC9kaXY+PGRpdj5BbmQgbm93IEkgaGF2ZSBhIHNpbXBsZSBpZGVhLCBidXQgSSBkb24ndCBr
bm93IGlmIGl0IGlzIHBvc3NpYmxlLiBXaGVuIHRoZSBIWVAgbW9kZSBpcyBpbml0LCB3ZSBjcmVh
dGUgYSBtYXBwaW5nIGZyb20gb25lIHNwZWNpYWwgdmlydHVhbCBhZGRyZXNzIHRvIHNvbWUgcGh5
c2ljYWwgYWRkcmVzcy4gQW5kIG1hcCB0aGUgdmEgdG8gSFlQIG1vZGUuIFdoZW4gd2Ugd2FudCB0
byByZWFkIHRoZSB2YWx1ZSBvZiBzb21lIFBBLCB3ZSBtb2RpZnkgdGhlIHBhZ2UgdGFibGUgdG8g
bGV0IHRoZSBzcGVjaWFsIFZBIG1hcCB0byB0aGUgUEEsIHRoZW4gd2UgcmVhZCB0aGUgc3BlY2lh
bCBWQSBhbmQgZ2V0IHRoZSB2YWx1ZSBvZiB0aGUgUEEuIEJlY2F1c2UgSSBvbmx5IHN0YXJ0IHRv
IHJlc2VhcmNoIG9uIHRoZSBLVk0sIHNvIEkgYW0gbm90IHN1cmUgaWYgdGhpcyBjYW4gd29yay4g
SSBob3BlIHRvIGdldCBoZWxwIHRvIGFjaGlldmUgdGhpcy48L2Rpdj48ZGl2Pjxicj48L2Rpdj48
ZGl2PlRoYW5rcyBhbmQgcmVnYXJkcyw8L2Rpdj48ZGl2PkhhcnJ5PC9kaXY+PC9kaXY+
------=_Part_46926_1904805325.1439776760161--


--===============3149291469192069755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3149291469192069755==--
