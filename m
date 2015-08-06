From: harry <tiancaixiaoyu90@126.com>
Subject: KVM/ARM: Problems about intercepting the system call
Date: Thu, 6 Aug 2015 13:45:58 +0800 (CST)
Message-ID: <172c4497.14e9b.14f018b6afd.Coremail.tiancaixiaoyu90@126.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2496611818739449177=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 567F85A296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 01:33:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j3TIA829D7Ap for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2015 01:33:10 -0400 (EDT)
Received: from m15-64.126.com (m15-64.126.com [220.181.15.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D9AB5A174
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 01:33:09 -0400 (EDT)
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

--===============2496611818739449177==
Content-Type: multipart/alternative;
	boundary="----=_Part_333612_2122347708.1438839958268"

------=_Part_333612_2122347708.1438839958268
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64

SGksCgpJIHdhbnQgdG8gdXNlIGt2bS9BUk0gdG8gaW50ZXJjZXB0IHRoZSBzeXN0ZW0gY2FsbC4g
SSBrbm93IHNldCBIQ1JfVEdFIHRvIDEgY2FuIGludGVyY2VwdCB0aGUgc3lzdGVtIGNhbGwuIEJ1
dCB3aGVuIEkgcmVzZWFyY2ggb24gWGVuLCBJIGtub3cgdGhpcyBpcyBub3QgYSB2ZXJ5IGdvb2Qg
d2F5LiBBbmQgd2hlbiBJIHNldCBIQ1JfVEdFIHRvIDEsIGl0IHdpbGwgaGF2ZSBhIG5vdGljZTog
VW5oYW5kbGVkIHByZWZldGNoIGFib3J0OiBicmVha3BvaW50IGRlYnVnIGV4Y2VwdGlvbiAoMHgy
MjIpIGF0IDB4MDAwMDgwZTAuIEFuZCB0aGVuIGEga2VybmVsIHBhbmljLgpTbyBJIHdhbnQgdG8g
a25vdyBpZiB0aGVyZSBhcmUgc29tZSBvdGhlciB3YXlzIHRvIGFjaGlldmUgdGhpcy4KClRoYW5r
cyBhbmQgcmVnYXJkcywKSGFycnkK
------=_Part_333612_2122347708.1438839958268
Content-Type: text/html; charset=GBK
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0ibGluZS1oZWlnaHQ6MS43O2NvbG9yOiMwMDAwMDA7Zm9udC1zaXplOjE0cHg7
Zm9udC1mYW1pbHk6QXJpYWwiPjxkaXY+SGksPGJyPjxicj5JIHdhbnQgdG8gdXNlIGt2bS9BUk0g
dG8gaW50ZXJjZXB0IHRoZSBzeXN0ZW0gY2FsbC4gSSBrbm93IHNldCBIQ1JfVEdFIHRvIDEgY2Fu
IGludGVyY2VwdCB0aGUgc3lzdGVtIGNhbGwuIEJ1dCB3aGVuIEkgcmVzZWFyY2ggb24gWGVuLCBJ
IGtub3cgdGhpcyBpcyBub3QgYSB2ZXJ5IGdvb2Qgd2F5LiBBbmQgd2hlbiBJIHNldCBIQ1JfVEdF
IHRvIDEsIGl0IHdpbGwgaGF2ZSBhIG5vdGljZTogVW5oYW5kbGVkIHByZWZldGNoIGFib3J0OiBi
cmVha3BvaW50IGRlYnVnIGV4Y2VwdGlvbiAoMHgyMjIpIGF0IDB4MDAwMDgwZTAuIEFuZCB0aGVu
IGEga2VybmVsIHBhbmljLjxicj5TbyBJIHdhbnQgdG8ga25vdyBpZiB0aGVyZSBhcmUgc29tZSBv
dGhlciB3YXlzIHRvIGFjaGlldmUgdGhpcy48YnI+PGJyPlRoYW5rcyBhbmQgcmVnYXJkcyw8YnI+
SGFycnk8YnI+PC9kaXY+PC9kaXY+PGJyPjxicj48c3BhbiB0aXRsZT0ibmV0ZWFzZWZvb3RlciI+
PHNwYW4gaWQ9Im5ldGVhc2VfbWFpbF9mb290ZXIiPjwvc3Bhbj48L3NwYW4+
------=_Part_333612_2122347708.1438839958268--


--===============2496611818739449177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2496611818739449177==--
